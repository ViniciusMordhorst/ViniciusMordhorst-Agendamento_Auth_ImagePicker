import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:agendamento/controller/notificacaodb.dart';

class Notificacaotela extends StatefulWidget {
  @override
  _NotificacaotelaState createState() => _NotificacaotelaState();
}

class _NotificacaotelaState extends State<Notificacaotela> {
  final CollectionReference notificacoesCollection =
      FirebaseFirestore.instance.collection("Notificacoes");

  // Método para excluir todas as notificações
  void _limparNotificacoes() async {
    var snapshots = await notificacoesCollection.get();
    for (var doc in snapshots.docs) {
      await doc.reference.delete();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[400],
      appBar: AppBar(
        title: const Text("Notificações"),
        backgroundColor: Colors.blue[400],
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _limparNotificacoes,
            tooltip: "Limpar notificações",
          ),
        ],
      ),
      body: SafeArea(
        child: StreamBuilder(
          stream: notificacoesCollection.snapshots(), // Mudamos para a coleção de notificações
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text("Nenhuma notificação disponível."));
            }

            return ListView(
  padding: const EdgeInsets.all(16),
  children: snapshot.data!.docs.map((doc) {
    String nome = doc['Nome'] ?? "Paciente desconhecido";
    String status = doc['status'] ?? "agendada"; // Obtém o status
    Timestamp timestamp = doc['timestamp'] ?? Timestamp.now();

    // Define a mensagem com base no status da notificação
    String mensagem = status == "cancelada"
        ? "Consulta de $nome cancelada com sucesso."
        : "Consulta de $nome agendada com sucesso.";

    String horaCancelamento = "${timestamp.toDate()}";

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        title: Text(mensagem),
        subtitle: Text("Data: $horaCancelamento"),
      ),
    );
  }).toList(),
);

          },
        ),
      ),
    );
  }
}
