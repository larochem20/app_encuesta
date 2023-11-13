import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_encuesta/encuesta.dart';

class screen_getall_encuesta extends StatefulWidget {
  @override
  _screen_getall_encuestaState createState() => _screen_getall_encuestaState();
}

class _screen_getall_encuestaState extends State<screen_getall_encuesta> {
  Future<List<Map<String, dynamic>>> obtenerDetallesEncuestas() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('encuestas').get();
    if (querySnapshot.docs.isNotEmpty) {
      return querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id; 
        return data;
      }).toList();
    } else {
      return [];
    }
  }

  void eliminarEncuestaYActualizarLista(String encuestaID) async {
    await eliminarEncuesta(encuestaID);
    setState(() {
      // Aquí debes actualizar la lista de encuestas después de eliminar
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Encuestas'),
      ),
      body: FutureBuilder(
        future: obtenerDetallesEncuestas(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error al cargar las encuestas'));
          } else if (!snapshot.hasData || (snapshot.data as List).isEmpty) {
            return Center(child: Text('No se encontraron encuestas'));
          } else {
            List<Map<String, dynamic>> encuestas = snapshot.data as List<Map<String, dynamic>>;

            return ListView.builder(
              itemCount: encuestas.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(encuestas[index]['nombre']), 
                  subtitle: Text(encuestas[index]['descripcion']),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetallesEncuestaScreen(encuesta: encuestas[index]),
                      ),
                    );
                  },
                  onLongPress: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Eliminar Encuesta'),
                          content: Text('¿Estás seguro que deseas eliminar esta encuesta?'),
                          actions: [
                            TextButton(
                              child: Text('Cancelar'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            TextButton(
                              child: Text('Eliminar'),
                              onPressed: () async {
                                String encuestaID = encuestas[index]['id'];
                                Navigator.of(context).pop();
                                eliminarEncuestaYActualizarLista(encuestaID);
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
    
  }
  
}
class DetallesEncuestaScreen extends StatelessWidget {
  final Map<String, dynamic> encuesta;

  DetallesEncuestaScreen({required this.encuesta});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(encuesta['nombre']), 
      ),
      body: ListView(
        children: encuesta['campos']
            .map<Widget>(
              (campo) => ListTile(
                title: Text(campo['nombre']), 
                subtitle: Text(campo['titulo']), 
              ),
            )
            .toList(),
      ),
    );
  }
}