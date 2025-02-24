import 'package:agendamento/controller/firestore.dart';
import 'package:agendamento/views/agendar.dart';
import 'package:agendamento/views/consultas.dart';
import 'package:agendamento/views/hometab.dart';
import 'package:agendamento/views/hospitais.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:agendamento/model/medico.dart'; // Importando o modelo Medico

class Medicos extends StatefulWidget {
  const Medicos({super.key});

  @override
  State<Medicos> createState() => _MedicosState();
}

class _MedicosState extends State<Medicos> {
  final FirestoreService firestoreService = FirestoreService();
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController especialidadeController = TextEditingController();

  void _navigateToScreen(Widget telas) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => telas),
    );
  }

  void abrirCaixaTF({String? docID, String? nomeInicial, String? especialidadeInicial}) {
  nomeController.text = nomeInicial ?? "";
  especialidadeController.text = especialidadeInicial ?? "";

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(docID == null ? "Adicionar Médico" : "Atualizar Médico"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: nomeController,
            decoration: const InputDecoration(labelText: "Nome do Médico"),
          ),
          TextField(
            controller: especialidadeController,
            decoration: const InputDecoration(labelText: "Especialidade"),
          ),
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            String nome = nomeController.text.trim();
            String especialidade = especialidadeController.text.trim();

            // Verifique se os valores não são nulos ou vazios
            if (nome.isEmpty || especialidade.isEmpty) {
              // Exibe um alerta ou impede a ação de adicionar/atualizar
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Por favor, preencha todos os campos!')),
              );
            } else {
              // Cria o objeto Medico
              Medico medico = Medico(nome, especialidade);

              if (docID == null) {
                firestoreService.addMedico(medico);
              } else {
                firestoreService.updateMedico(docID, nome, especialidade);
              }

              Navigator.pop(context);
            }
          },
          child: Text(docID == null ? "Adicionar" : "Atualizar"),
        ),
      ],
    ),
  );
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[400],
      appBar: AppBar(
        backgroundColor: Colors.blue[400],
        title: const Text('Lista de Médicos'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestoreService.getMedicoStream(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List listaMedicos = snapshot.data!.docs;
            return ListView.builder(
              itemCount: listaMedicos.length,
              itemBuilder: (context, index) {
                DocumentSnapshot document = listaMedicos[index];
                String docID = document.id;
                Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                String medicoNome = data['nome'];
                String especialidade = data['especialidade'] ?? "Não informado";

                return Card(
                  color: Colors.white,
                  child: ListTile(
                    leading: const Icon(Icons.account_circle, size: 32, color: Colors.lightBlueAccent),
                    title: Text(medicoNome),
                    subtitle: Text("Especialidade: $especialidade"),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () => abrirCaixaTF(docID: docID, nomeInicial: medicoNome, especialidadeInicial: especialidade),
                          icon: const Icon(Icons.update, color: Colors.amber),
                        ),
                        IconButton(
                          onPressed: () => firestoreService.deleteMedico(docID),
                          icon: const Icon(Icons.delete, color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(child: Text("Nenhum médico cadastrado..."));
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
}
