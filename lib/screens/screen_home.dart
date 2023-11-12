import 'package:flutter/material.dart';
import 'package:flutter_encuesta/screens/screen_encuesta.dart';
import 'package:flutter_encuesta/screens/screen_get_encuesta.dart';
import 'package:flutter_encuesta/screens/screen_getall_encuesta.dart';

class screen_home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gestor de Encuestas'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
         
                Navigator.push(
                  context,
                    MaterialPageRoute(builder: (context) => screen_encuesta()),
    );
              },
              child: Text('Crear Encuesta'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                    MaterialPageRoute(builder: (context) => screen_getall_encuesta()),
    );
              },
              child: Text('Ver Encuestas Creadas'),
            ),
          ],
        ),
      ),
    );
  }
}
