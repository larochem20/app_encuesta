import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class screen_encuesta extends StatefulWidget {
  @override
  _screen_encuestaState createState() => _screen_encuestaState();
}

class _screen_encuestaState extends State<screen_encuesta> {
  String nombre = '';
  String titulo = '';
  String descripcion = '';
  List<Map<String, dynamic>> campos = [];
  void agregarCampo() {
    setState(() {
      campos.add({
        'nombre': '',
        'titulo': '',
        'esRequerido': true,
        'tipoCampo': 'Texto',
      });
    });
  }

Future<void> crearEncuesta() async {
  if (nombre.isNotEmpty && titulo.isNotEmpty && descripcion.isNotEmpty && campos.isNotEmpty) {
    bool camposNoVacios = campos.every((campo) {
      return campo['nombre'].isNotEmpty &&
          campo['titulo'].isNotEmpty &&
          campo['esRequerido'] != null &&
          campo['tipoCampo'] != null;
    });

    if (camposNoVacios) {
      DocumentReference encuestaRef = await FirebaseFirestore.instance.collection('encuestas').add({
        'nombre': nombre,
        'titulo': titulo,
        'descripcion': descripcion,
        'campos': campos,
      });
      print('Encuesta creada');
      String encuestaId = encuestaRef.id; 

     
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Encuesta creada con ID: $encuestaId'),
          action: SnackBarAction(
            label: 'Copiar',
            onPressed: () {
              Clipboard.setData(ClipboardData(text: encuestaId));
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('ID copiado')));
            },
          ),
        ),
      );


      setState(() {
        nombre = '';
        titulo = '';
        descripcion = '';
        campos.clear();
      });


    } else {
      print('Por favor, complete todos los campos en la lista de campos.');
    }
  } else {
    print('Por favor, complete todos los campos.');
  }
}




  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('Crear Encuesta'),
    ),
    body: SingleChildScrollView(
      child: Column(
        children: [
          TextFormField(
            onChanged: (value) {
              setState(() {
              nombre = value;
              });
                },
                    decoration: InputDecoration(labelText: 'Nombre de encuesta'),
                ),
                TextFormField(
            onChanged: (value) {
              setState(() {
              titulo = value;
              });
                },
                    decoration: InputDecoration(labelText: 'Titulo de encuesta'),
                ),
                TextFormField(
            onChanged: (value) {
              setState(() {
              descripcion = value;
              });
                },
                    decoration: InputDecoration(labelText: 'Descripcion de encuesta'),
                ),
                  ElevatedButton(
            onPressed: agregarCampo,
            child: Text('Agregar Campo'),
          ),
          ...campos.asMap().entries.map(
            (entry) {
              int index = entry.key;
              Map<String, dynamic> campo = entry.value;
              return Column(
                children: [
                  TextFormField(
                    onChanged: (value) {
                      setState(() {
                        campos[index]['nombre'] = value;
                      });
                    },
                    decoration: InputDecoration(labelText: 'Nombre del campo'),
                  ),
                  TextFormField(
                    onChanged: (value) {
                      setState(() {
                        campos[index]['titulo'] = value;
                      });
                    },
                    decoration: InputDecoration(labelText: 'Título del campo'),
                  ),

                  Checkbox(
                    value: campos[index]['esRequerido'] ?? false,
                    onChanged: (value) {
                      setState(() {
                        campos[index]['esRequerido'] = value;
                          });
                        },
                      ),
                    Text('El campo es requerido?'
                    ),
                  DropdownButtonFormField<String>(
  value: campos[index]['tipoCampo'],
  items: <String>['Texto', 'Número', 'Fecha'].map((String value) {
    return DropdownMenuItem<String>(
      value: value,
      child: Text(value),
    );
  }).toList(),
  onChanged: (String? value) {
    setState(() {
      campos[index]['tipoCampo'] = value ?? ''; 
    });
  },
),

                ],
              );
            },
          ),
          ElevatedButton(
  onPressed: () {
 
    crearEncuesta(); 
  },
  child: Text('Guardar Encuesta en Firestore'),
),

        ],
      ),
    ),
  );
}
Map<String, dynamic> prepararDatosEncuesta() {
    Map<String, dynamic> encuestaData = {
      'nombre': 'Nombre de la encuesta',
      'titulo': 'Título de la encuesta',
      'descripcion': 'Descripción de la encuesta',
      'campos': campos,
    };

    return encuestaData;
  }
  
}
