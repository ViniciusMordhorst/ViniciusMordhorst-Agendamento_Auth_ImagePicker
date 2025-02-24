import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:image_picker/image_picker.dart';
import 'package:agendamento/model/user.dart';

class UserDBcontroller {
  final firebase_auth.FirebaseAuth _auth = firebase_auth.FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference collection =
      FirebaseFirestore.instance.collection("Usuario");

  // Obtém o usuário autenticado (se existir)
  firebase_auth.User? _getAuthenticatedUser() {
    return _auth.currentUser;
  }

  // Adiciona um novo usuário ao Firestore (sem necessidade de autenticação)
  Future<void> adicionarUsuario(User usuario) async {
    try {
      await collection.add(usuario.toFirebase());
    } catch (e) {
      throw Exception("Erro ao adicionar usuário: $e");
    }
  }

  // Atualiza os dados do usuário no Firestore (somente se autenticado)
  Future<void> updateUsuario(User usuario) async {
    final firebase_auth.User? user = _getAuthenticatedUser();
    if (user == null) {
      throw Exception("Usuário não autenticado");
    }

    try {
      await collection.doc(user.uid).update(usuario.toFirebase());
    } catch (e) {
      throw Exception("Erro ao atualizar usuário: $e");
    }
  }

  // Obtém os dados do usuário autenticado no Firestore
  Future<User> getUsuario() async {
    final firebase_auth.User? user = _getAuthenticatedUser();
    if (user == null) {
      throw Exception("Usuário não autenticado");
    }

    try {
      final DocumentSnapshot result = await collection.doc(user.uid).get();
      if (result.exists) {
        return User.fromFirebase(result);
      } else {
        throw FirebaseException(
            message: "Usuário não encontrado.", plugin: "cloud_firestore");
      }
    } catch (e) {
      throw Exception("Erro ao obter usuário: $e");
    }
  }

  // Salva a imagem do usuário no Firestore (como Base64)
  Future<void> salvarImagemUsuario(XFile imageFile) async {
    final firebase_auth.User? user = _getAuthenticatedUser();
    if (user == null) {
      throw Exception("Usuário não autenticado");
    }

    try {
      List<int> imageBytes = await File(imageFile.path).readAsBytes();
      String base64Image = base64Encode(imageBytes);

      await collection.doc(user.uid).update({"foto": base64Image});
    } catch (e) {
      throw Exception("Erro ao salvar imagem: $e");
    }
  }

  // Carrega a imagem do usuário do Firestore
  Future<String?> carregarImagemUsuario() async {
    final firebase_auth.User? user = _getAuthenticatedUser();
    if (user == null) {
      throw Exception("Usuário não autenticado");
    }

    try {
      final DocumentSnapshot result = await collection.doc(user.uid).get();
      return result.exists ? result["foto"] as String? : null;
    } catch (e) {
      throw Exception("Erro ao carregar imagem: $e");
    }
  }
}
