import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:agendamento/model/agendamento.dart';
import 'package:agendamento/views/agendar.dart';
import 'package:agendamento/views/hometab.dart';
import 'package:agendamento/views/hospitais.dart';
import 'package:agendamento/views/medicos.dart';
import 'package:agendamento/controller/agendamentoDBController.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Consultas extends StatefulWidget {
  const Consultas({super.key});

  @override
  State<Consultas> createState() => _ConsultasState();
}

class _ConsultasState extends State<Consultas> {
  final AgendamentoDBController dbController = AgendamentoDBController();
  String userId = FirebaseAuth.instance.currentUser?.uid ?? ''; // Obtendo o userId do usuário logado

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[400],
      appBar: AppBar(
        title: const Text("Suas Consultas"),
        backgroundColor: Colors.blue[400],
      ),
      body: SafeArea(
        child: FutureBuilder<List<Agendamento>>(
          future: dbController.getAgendamentos(), // Usando o método da classe AgendamentoDBController
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text("Erro: ${snapshot.error}"));
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text("Nenhuma consulta agendada."));
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Agendamento agendamento = snapshot.data![index];
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
                    onPressed: () {
                      if (agendamento.userId == null || agendamento.userId!.isEmpty) {
                      // Tratar o caso em que userId é nulo ou vazio
                        print('Usuário não autenticado');
                      } else {
                        _confirmarRemocao(agendamento.id!, agendamento.nome ?? "Paciente");
                      }
                    },

                    ),
                  ),
                );
              },
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

  void _navigateToScreen(Widget telas) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => telas),
    );
  }

  void _confirmarRemocao(String docId, String nome) {
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
                _cancelarAgendamento(docId, nome);
                Navigator.of(context).pop();
              },
              child: const Text("Sim"),
            ),
          ],
        );
      },
    );
  }

  void _cancelarAgendamento(String docId, String nome) {
    dbController.cancelarAgendamento(docId, nome, userId);
  }
}
