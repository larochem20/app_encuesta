import 'package:flutter/material.dart';
import 'package:flutter_encuesta/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_encuesta/screens/screen_encuesta.dart';
import 'package:flutter_encuesta/screens/screen_get_encuesta.dart';
import 'package:flutter_encuesta/screens/screen_home.dart';

class screen_auth extends StatelessWidget {
 TextEditingController codigoController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void registrarUsuario() async {
    var usuarioRegistrado = await registerWithEmailAndPassword(emailController.text, passwordController.text);
    if (usuarioRegistrado != null) {
      print('Usuario registrado: ${usuarioRegistrado.email}');
    
    } else {
      print('El registro falló');
   
    }
  }

  void iniciarSesion(BuildContext context) async {
    String email = emailController.text;
    String password = passwordController.text;
    User? user = await singInEmailPass(email, password);

    if (user != null) {
      print('Inicio de sesión exitoso para ${user.email}');
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => screen_home()),
      );
    } else {
      print('El inicio de sesión ha fallado');
     
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Correo electrónico',
              ),
            ),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Contraseña',
              ),
            ),
            ElevatedButton(
              onPressed: () => iniciarSesion(context),
              child: Text('Iniciar Sesión'),
            ),
            TextFormField(
              controller: codigoController,
              decoration: InputDecoration(
                labelText: 'Ingrese código de encuesta',
              ),
            ),
            ElevatedButton(
              onPressed: () {
                String codigoEncuesta = codigoController.text;
                if (codigoEncuesta.isNotEmpty) {
                  Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => screen_get_encuesta(codigoEncuesta),
        ),
      );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Por favor, ingrese un código de encuesta.'),
                    ),
                  );
                }
              },
              child: Text('Ir a responder encuesta'),
            ),
          ],
        ),
      ),
    );
  }
}
