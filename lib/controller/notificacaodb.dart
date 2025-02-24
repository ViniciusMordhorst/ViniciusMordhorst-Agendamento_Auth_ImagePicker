import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NotificacaoDB {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Método para salvar notificação de agendamento
 Future<void> salvarNotificacao(String nome, String hora, String data) async {
    try {
      // Obtém o userId do usuário autenticado
      String? userId = FirebaseAuth.instance.currentUser?.uid;
      
      if (userId != null) {
        // Adiciona a notificação com o userId
        await _db.collection('Notificacoes').add({
          'nome': nome,
          'data': data,
          'hora': hora,
          'userId': userId, // Associando a notificação ao usuário logado
          'timestamp': FieldValue.serverTimestamp(),
          'status': 'agendada', // Status inicial
        });

        print("Notificação de agendamento salva.");
      } else {
        print("Erro: Nenhum usuário logado.");
      }
    } catch (e) {
      print("Erro ao salvar notificação: $e");
    }
  

  }

  // Método para atualizar a notificação quando a consulta for cancelada
  Future<void> cancelarAgendamento(String docId, String nome) async {
    try {
      DocumentReference docRef = _db.collection("Notificacoes").doc(docId);
      
      // Verifica se o documento existe antes de atualizar
      DocumentSnapshot doc = await docRef.get();
      if (doc.exists) {
        // Verifica se a notificação pertence ao usuário logado
        String? userId = FirebaseAuth.instance.currentUser?.uid;
        
        if (userId != null && doc['userId'] == userId) {
          // Atualiza a notificação para "cancelada"
          await docRef.update({
            "status": "cancelada",
            "mensagem": "Consulta no nome de $nome foi cancelada.",
            'timestamp': FieldValue.serverTimestamp(),
          });

          print("Notificação de cancelamento registrada.");
        } else {
          print("Erro: A notificação não pertence ao usuário logado.");
        }
      } else {
        print("Erro: Documento da notificação não encontrado.");
      }
    } catch (e) {
      print("Erro ao atualizar notificação: $e");
    }
  }

  // Método para buscar notificações de um usuário logado
  Future<List<Map<String, dynamic>>> getNotificacoes() async {
    try {
      // Obtém o userId do usuário autenticado
      String? userId = FirebaseAuth.instance.currentUser?.uid;
      
      if (userId != null) {
        // Filtra as notificações pelo userId
        QuerySnapshot querySnapshot = await _db
            .collection('Notificacoes')
            .where('userId', isEqualTo: userId)
            .get();

        return querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
      } else {
        print("Erro: Nenhum usuário logado.");
        return [];
      }
    } catch (e) {
      print("Erro ao obter notificações: $e");
      return [];
    }
  }
}
