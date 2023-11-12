import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> crearEncuesta(String nombre, String titulo, String descripcion, List<Map<String, dynamic>> campos) async {
  await FirebaseFirestore.instance.collection('encuestas').add({
    'nombre': nombre,
    'titulo': titulo,
    'descripcion': descripcion,
    'campos': campos,
  });
}
//obtener todas las encuestas
Future<List<Map<String, dynamic>>> obtenerTodasEncuestas() async {
  QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('encuestas').get();
  if (querySnapshot.docs.isNotEmpty) {
    return querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
  } else {
    return [];
  }
}
//obtener encuesta por ID
Future<Map<String, dynamic>> obtenerDetallesEncuesta(String encuestaID) async {
  DocumentSnapshot encuestaSnapshot = await FirebaseFirestore.instance.collection('encuestas').doc(encuestaID).get();
  if (encuestaSnapshot.exists) {
    return encuestaSnapshot.data() as Map<String, dynamic>;
  } else {
    return Map<String, dynamic>(); 
  }
}
