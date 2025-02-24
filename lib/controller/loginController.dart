import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Método para validar login com e-mail e senha
  Future<bool> validarLogin(String email, String senha) async {
    try {
      // Tentar autenticar com Firebase Authentication
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: senha,
      );

      // Verificar se o usuário existe no Firestore
      DocumentSnapshot userDoc = await _db
          .collection('Usuario')
          .doc(userCredential.user!.uid) // Busca pelo UID do FirebaseAuth
          .get();

      if (userDoc.exists) {
        return true; // Login bem-sucedido
      } else {
        return false; // Usuário não encontrado no Firestore
      }
    } on FirebaseAuthException catch (e) {
      print("Erro ao autenticar usuário: ${e.message}");
      return false; // Retorna falso em caso de erro de autenticação
    } catch (e) {
      print("Erro ao validar login: $e");
      return false;
    }
  }
}
