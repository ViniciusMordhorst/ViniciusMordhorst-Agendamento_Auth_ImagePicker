import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:agendamento/model/agendamento.dart';
import 'package:agendamento/views/agendar.dart';
import 'package:agendamento/views/hometab.dart';
import 'package:agendamento/views/hospitais.dart';
import 'package:agendamento/views/medicos.dart';
import 'package:agendamento/controller/agendamentoDBController.dart';

class Consultas extends StatefulWidget {
  const Consultas({super.key});

  @override
  State<Consultas> createState() => _ConsultasState();
}

class _ConsultasState extends State<Consultas> {
  final AgendamentoDBController dbController = AgendamentoDBController();
  final CollectionReference agendamentosCollection =
      FirebaseFirestore.instance.collection("Agendamento");

  String userId = 'exemplo_user_id'; // Substitua por seu método de obter o userId

  void _navigateToScreen(Widget telas) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => telas),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[400],
      appBar: AppBar(
        title: const Text("Suas Consultas"),
        backgroundColor: Colors.blue[400],
      ),
      body: SafeArea(
        child: StreamBuilder(
          stream: agendamentosCollection.snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text("Nenhuma consulta agendada."));
            }

            return ListView(
              padding: const EdgeInsets.all(16),
              children: snapshot.data!.docs.map((doc) {
                Agendamento agendamento = Agendamento.fromFirebase(doc);
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    title: Text(agendamento.nome ?? "Paciente desconhecido"),
                    subtitle: Text(
                        "Data: ${agendamento.data} • Hora: ${agendamento.hora}"),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _confirmarRemocao(doc.id, agendamento.nome ?? "Paciente", userId),
                    ),
                  ),
                );
              }).toList(),
            );
          },
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          switch (index) {
            case 0:
              _navigateToScreen(const Hospitais());
              break;
            case 1:
              _navigateToScreen(const Agendar());
              break;
            case 2:
              _navigateToScreen(const Medicos());
              break;
            case 3:
              _navigateToScreen(const Consultas());
              break;
            case 4:
              _navigateToScreen(const Hometab());
              break;
          }
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.blue[600],
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.local_hospital_sharp),
            label: 'Hospitais',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month_sharp),
            label: 'Agendar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.medical_services_sharp),
            label: 'Médicos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: 'Consultas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }

  void _confirmarRemocao(String docId, String nome, String userId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Cancelar Consulta"),
          content: const Text("Tem certeza de que deseja cancelar esta consulta?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Não"),
            ),
            TextButton(
              onPressed: () {
                _cancelarAgendamento(docId, nome, userId);
                Navigator.of(context).pop();
              },
              child: const Text("Sim"),
            ),
          ],
        );
      },
    );
  }

  void _cancelarAgendamento(String docId, String nome, String userId) {
    dbController.cancelarAgendamento(docId, nome, userId);
  }
}
