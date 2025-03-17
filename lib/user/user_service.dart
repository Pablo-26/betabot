import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>?> getUserData() async {
    try {
      // Obtén el usuario autenticado actual
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        print('Usuario no autenticado.');
        return null;
      }

      // Obtén los datos del usuario desde Firestore
      DocumentSnapshot snapshot = await firestore
          .collection('users') // Asegúrate de que esta colección exista en Firestore
          .doc(user.uid) // Usa el UID del usuario autenticado
          .get();

      if (snapshot.exists) {
        return snapshot.data() as Map<String, dynamic>;
      } else {
        print('Documento de usuario no encontrado.');
        return null;
      }
    } catch (e) {
      print('Error al obtener datos del usuario: $e');
      return null;
    }
  }
}

