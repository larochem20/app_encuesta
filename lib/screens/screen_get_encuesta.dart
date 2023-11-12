import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class screen_get_encuesta extends StatefulWidget  {
final String encuestaId;

  screen_get_encuesta(this.encuestaId);

  @override
  _screen_get_encuestaState createState() => _screen_get_encuestaState();
}

class _screen_get_encuestaState extends State<screen_get_encuesta> {
  final TextEditingController codigoController = TextEditingController();
  List<String> respuestas = [];

  Future<Map<String, dynamic>> obtenerDetallesEncuesta(String encuestaID) async {
    DocumentSnapshot encuestaSnapshot =
        await FirebaseFirestore.instance.collection('encuestas').doc(encuestaID).get();
    if (encuestaSnapshot.exists) {
      return encuestaSnapshot.data() as Map<String, dynamic>;
    } else {
      return Map<String, dynamic>();
    }
  }

  void guardarRespuesta(String respuesta) {
    respuestas.add(respuesta);
  }

Future<void> enviarRespuestas() async {
  final user = FirebaseAuth.instance.currentUser;

  final existingResponse = await FirebaseFirestore.instance
      .collection('respuestas')
      .where('usuario', isEqualTo: user?.uid)
      .where('encuesta', isEqualTo: widget.encuestaId)
      .get();

  if (existingResponse.docs.isEmpty) {
    await FirebaseFirestore.instance.collection('respuestas').add({
      'usuario': user?.uid ?? '', 
      'encuesta': widget.encuestaId,
      'valores': respuestas,
    });
  
    respuestas.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('¡Respuestas enviadas!'),
      ),
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('¡Ya has enviado respuestas para esta encuesta!'),
      ),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Responder Encuesta'),
      ),
      body: FutureBuilder(
        future: obtenerDetallesEncuesta(widget.encuestaId),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error al cargar los detalles de la encuesta'));
          } else if (!snapshot.hasData || (snapshot.data as Map).isEmpty) {
            return Center(child: Text('No se encontraron detalles para la encuesta'));
          } else {
            Map<String, dynamic> encuestaData = snapshot.data as Map<String, dynamic>;

            return ListView(
              children: [
                ListTile(
                  title: Text(encuestaData['nombre']),
                  subtitle: Text(encuestaData['descripcion']),
                ),
                for (var campo in encuestaData['campos']) ...[
                  ListTile(
                    title: Text('Campo: ${campo['titulo']}'),
                  ),
                  TextFormField(
                    onChanged: (value) {
                      guardarRespuesta(value);
                    },
                    decoration: InputDecoration(
                      labelText: 'Responder ${campo['titulo']}',
                    ),
                  ),
                ],
                ElevatedButton(
                  onPressed: () {
                    if (respuestas.isNotEmpty) {
                      enviarRespuestas();
                    
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('¡No hay respuestas para enviar!'),
                        ),
                      );
                    }
                  },
                  child: Text('Enviar respuestas'),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
