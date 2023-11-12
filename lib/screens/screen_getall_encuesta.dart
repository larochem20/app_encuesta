import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class screen_getall_encuesta extends StatelessWidget {
  Future<List<Map<String, dynamic>>> obtenerDetallesEncuestas() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('encuestas').get();
    if (querySnapshot.docs.isNotEmpty) {
      return querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    } else {
      return [];
    }
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
