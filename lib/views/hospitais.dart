import 'package:agendamento/controller/firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:agendamento/views/agendar.dart';
import 'package:agendamento/views/consultas.dart';
import 'package:agendamento/views/hometab.dart';
import 'package:agendamento/views/medicos.dart';
import 'package:flutter/material.dart';

class Hospitais extends StatefulWidget {
  const Hospitais({super.key});

  @override
  State<Hospitais> createState() => _HospitaisState();
}

class _HospitaisState extends State<Hospitais> {
  final FirestoreService firestoreService = FirestoreService();
  final TextEditingController textController = TextEditingController();

  void _navigateToScreen(Widget telas) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => telas),
    );
  }

  void abrirCaixaTF({String? docID}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: TextField(
          controller: textController,
        ),
        actions: [
          // Botão salvar
          ElevatedButton(
            onPressed: () {
              // Adicionar hospital
              if (docID == null) {
                firestoreService.addHospital(textController.text);
              } else {
                firestoreService.updateHospital(docID, textController.text);
              }

              // Limpar o campo de texto
              textController.clear();

              // Fechar a caixa de texto
              Navigator.pop(context);
            },
            child: Text(docID == null ? "Adicionar" : "Atualizar"),
          ),
        ],
      ),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[400],
      appBar: AppBar(
        backgroundColor: Colors.blue[400],
        title: const Text('Lista de Hospitais'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestoreService.getHospitalStream(),
        builder: (context, snapshot) {
          // Se há dados, exibe a lista de hospitais
          if (snapshot.hasData) {
            List listaHospitais = snapshot.data!.docs;

            return ListView.builder(
              itemCount: listaHospitais.length,
              itemBuilder: (context, index) {
                // Pega o documento individual
                DocumentSnapshot document = listaHospitais[index];
                String docID = document.id;

                // Pega os dados do hospital
                Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                String hospitalNome = data['Nome'];

                return Card(
                  color: Colors.white,
                  child: ListTile(
                    leading: Icon(
                      Icons.account_circle,
                      size: 32,
                      color: Colors.lightBlueAccent,
                    ),
                    title: Text(hospitalNome),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Botão para atualizar
                        IconButton(
                          onPressed: () => abrirCaixaTF(docID: docID),
                          icon: const Icon(
                            Icons.update,
                            color: Colors.amber,
                          ),
                        ),
                        // Botão para excluir
                        IconButton(
                          onPressed: () => firestoreService.deleteHospital(docID),
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            // Se não houver dados, exibe uma mensagem
            return const Center(child: Text("Nenhum hospital cadastrado..."));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: abrirCaixaTF,
        backgroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          // Navegação por índice do BottomNavigationBar
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
}
