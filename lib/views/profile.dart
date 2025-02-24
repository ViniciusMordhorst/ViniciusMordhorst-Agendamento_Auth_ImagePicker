import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:agendamento/controller/UserDBController.dart';
import 'package:agendamento/views/Medicos.dart';
import 'package:agendamento/views/agendar.dart';
import 'package:agendamento/views/consultas.dart';
import 'package:agendamento/views/home.dart';
import 'package:agendamento/views/hospitais.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String? _imagemBase64;
  final UserDBcontroller _database = UserDBcontroller();
  String? userId;

  // Carregar o userId do Firebase Auth
  void _getUserId() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        userId = user.uid; // Atribui o uid do Firebase Auth
      });
      _carregarImagemDoFirebase();
    } else {
      // Caso o usuário não esteja logado
      print("Usuário não autenticado!");
    }
  }

  // Função para selecionar uma imagem
  Future<void> _selecionarImagem() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null && userId != null) {
        setState(() {
          _imagemBase64 = null;
        });

        // Converter a imagem para Base64
        final bytes = await pickedFile.readAsBytes();
        final base64Image = base64Encode(bytes);

        // Salvar a imagem Base64 no Firestore
        await FirebaseFirestore.instance.collection('Usuario').doc(userId).set({
          'foto': base64Image,
        }, SetOptions(merge: true));

        _carregarImagemDoFirebase();
      } else {
        print("Nenhuma imagem selecionada.");
      }
    } catch (e) {
      print("Erro ao selecionar imagem: $e");
    }
  }

  // Carregar a imagem do Firestore
  void _carregarImagemDoFirebase() async {
    if (userId != null) {
      try {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('Usuario').doc(userId).get();
        String? base64Image = userDoc['foto'];

        if (base64Image != null) {
          setState(() {
            _imagemBase64 = base64Image;
          });
        } else {
          print("Imagem não encontrada.");
        }
      } catch (e) {
        print("Erro ao carregar a imagem do Firestore: $e");
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _getUserId(); // Carregar o userId ao inicializar
  }

  // Navegação para outras telas
  void _navigateToScreen(Widget telas) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => telas),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          child: Column(
            children: [
              Image.asset(
                'assets/gato.png',
                width: 150,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: _selecionarImagem,
                child: const Text("Selecionar Imagem"),
              ),
              const SizedBox(height: 20.0),
              _imagemBase64 != null
                  ? Image.memory(
                      base64Decode(_imagemBase64!),
                      width: 300,
                    )
                  : const Text("Nenhuma imagem selecionada."),
            ],
          ),
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
              _navigateToScreen(const Home(uid: 'userId',));
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
