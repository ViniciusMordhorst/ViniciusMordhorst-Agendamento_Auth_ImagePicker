import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:agendamento/model/agendamento.dart';

class AgendamentoDBController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final firebase_auth.FirebaseAuth _auth = firebase_auth.FirebaseAuth.instance;
  final CollectionReference agendamentosCollection =
      FirebaseFirestore.instance.collection('Agendamento');

  // Obtém o usuário autenticado (se existir)
  firebase_auth.User? _getAuthenticatedUser() {
    return _auth.currentUser;
  }

  // Adiciona um novo agendamento
  Future<void> adicionarAgendamento(Agendamento agendamento) async {
    final firebase_auth.User? user = _getAuthenticatedUser();
    if (user == null) {
      throw Exception("Usuário não autenticado");
    }

    // Atribui o userId ao agendamento
    agendamento.userId = user.uid;

    try {
      await agendamentosCollection.add(agendamento.toFirebase());
    } catch (e) {
      throw Exception("Erro ao adicionar agendamento: $e");
    }
  }

  // Obtém os agendamentos do usuário autenticado
  Future<List<Agendamento>> getAgendamentos() async {
    final firebase_auth.User? user = _getAuthenticatedUser();
    if (user == null) {
      throw Exception("Usuário não autenticado");
    }

    try {
      // Filtra os agendamentos pelo userId do usuário autenticado
      QuerySnapshot querySnapshot = await agendamentosCollection
          .where('userId', isEqualTo: user.uid) // Filtra pelo userId
          .get();

      return querySnapshot.docs
          .map((doc) => Agendamento.fromFirebase(doc))
          .toList();
    } catch (e) {
      throw Exception("Erro ao buscar agendamentos: $e");
    }
  }

  // Remove um agendamento
  Future<void> cancelarAgendamento(String agendamentoId,String nome, String userId) async {
    try {
      await agendamentosCollection.doc(agendamentoId).delete();
    } catch (e) {
      throw Exception("Erro ao remover agendamento: $e");
    }
  }
}
