import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
String? uid;
String? name;
String? userEmail;

Future<User?> registerWithEmailAndPassword(String email, String password) async {
  await Firebase.initializeApp();
  User? user;

  try {
    UserCredential userCredential= await _auth.createUserWithEmailAndPassword(
      email: email, password: password,);
      user = userCredential.user;
      if (user !=null){

        uid = user.uid;
        userEmail= user.email;
      }
  } on FirebaseAuthException 
  catch (e) {
    if (e.code == 'weak-password'){
      print('The password provided is not weak');
    } else if (e.code == 'email-already-in-use'){
      print('The account already exits for that email');
    }
    
  }catch(e){
    print(e);
  }
  return user;
}
Future<User?> singInEmailPass(String email, String password) async {
  await Firebase.initializeApp();
  User? user;
  try {
    UserCredential userCredential = await _auth.signInWithEmailAndPassword( 
      email: email,
      password: password,
    );
    user = userCredential.user; 

    if (user != null) {
      uid = user.uid;
      userEmail = user.email;

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('auth', true);
    }
  } catch (e) {

    print('Error al iniciar sesión: $e');
  }
  return user;
}
Future<String> singOut() async {
  await _auth.signOut();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setBool('auth', false);
  uid =null;
  userEmail=null;
  return 'User signed out';
}
