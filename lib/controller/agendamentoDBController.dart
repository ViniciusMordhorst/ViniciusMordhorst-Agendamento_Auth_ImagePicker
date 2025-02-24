import 'package:agendamento/controller/notificacaodb.dart';
import 'package:agendamento/model/agendamento.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AgendamentoDBController {
  final CollectionReference _db = FirebaseFirestore.instance.collection("Agendamento");
  final CollectionReference _notificacoes = FirebaseFirestore.instance.collection("Notificacoes");
  final NotificacaoDB _notificacaoDB = NotificacaoDB(); // Instância correta da classe de notificações

  // Adicionar AgendamentodicionarAgendamento
  Future<void> adicionarAgendamento(Agendamento agendamento) async {
    try {
      // Adiciona um agendamento no Firestore
      await _db.add(agendamento.toFirebase());
      print("Agendamento adicionado com sucesso!");
    } catch (e) {
      print("Erro ao adicionar agendamento: $e");
    }
  }

  // Atualizar Agendamento
  Future<void> updateAgendamento(Agendamento agendamento, String docId) async {
    try {
      // Atualiza o agendamento com o id especificado
      await _db.doc(docId).update(agendamento.toFirebase());
      print("Agendamento atualizado com sucesso!");
    } catch (e) {
      print("Erro ao atualizar agendamento: $e");
    }
  }

// Método para obter os agendamentos de um usuário
  Future<List<Agendamento>> getAgendamentos(String userId) async {
    try {
      QuerySnapshot querySnapshot = await _db.where('userId', isEqualTo: userId).get();
      return querySnapshot.docs.map((doc) => Agendamento.fromFirebase(doc)).toList();
    } catch (e) {
      print("Erro ao obter agendamentos: $e");
      return [];
    }
  }

  // Cancelar Agendamento e salvar notificação
  Future<void> cancelarAgendamento(String docId, String nome, String userId) async {
    try {
      // Filtra as notificações para encontrar a notificação relacionada ao agendamento
      QuerySnapshot notificacoesSnapshot = await _notificacoes
          .where("nome", isEqualTo: nome)
          .where('userId', isEqualTo: userId) // Filtra as notificações pelo userId
          .get();

      if (notificacoesSnapshot.docs.isNotEmpty) {
        String notificacaoId = notificacoesSnapshot.docs.first.id;

        // Chama o método da NotificacaoDB para cancelar o agendamento
        await _notificacaoDB.cancelarAgendamento(notificacaoId, nome);
        print("Notificação de cancelamento enviada.");
      } else {
        print("Nenhuma notificação encontrada para $nome.");
      }

      // Remove o agendamento do banco de dados
      await _db.doc(docId).delete();
      print("Consulta de $nome cancelada.");
    } catch (e) {
      print("Erro ao cancelar agendamento: $e");
    }
  }
}
