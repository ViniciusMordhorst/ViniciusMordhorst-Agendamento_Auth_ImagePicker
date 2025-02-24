import 'package:agendamento/model/notificacao.dart';
import 'package:agendamento/views/agendar.dart';
import 'package:agendamento/views/consultas.dart';
import 'package:agendamento/views/Hospitais.dart';
import 'package:agendamento/views/Medicos.dart';
import 'package:agendamento/views/hometab.dart';
import 'package:agendamento/views/notificacaotela.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  final String uid; // Recebe o UID do usuário

  const Home({super.key, required this.uid});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0; // Para controle do índice da navegação no BottomNavigationBar

  void _navigateToScreen(Widget tela) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => tela),
    );
  }

  // Função para alterar o estado da tela com base na navegação no BottomNavigationBar
  void _onNavBarTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[400],
      appBar: AppBar(
        title: const Text('Tela Inicial'),
        backgroundColor: Colors.blue[400],
      ),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0,
          childAspectRatio: 1,
          children: <Widget>[
            // Adicione os Cards de navegação aqui
            Card(
              margin: const EdgeInsets.all(10.0),
              child: InkWell(
                splashColor: Colors.blueGrey,
                onTap: () {
                  _navigateToScreen(const Hospitais());
                },
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      IconButton(
                        icon: const Icon(
                          Icons.local_hospital_sharp,
                          size: 100.0,
                        ),
                        onPressed: () {
                          _navigateToScreen(const Hospitais());
                        },
                      ),
                      const Text(
                        "Hospitais",
                        style: TextStyle(fontSize: 17.0),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Card(
              margin: const EdgeInsets.all(10.0),
              child: InkWell(
                splashColor: Colors.blueGrey,
                onTap: () {
                  _navigateToScreen(const Agendar());
                },
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      IconButton(
                        icon: const Icon(
                          Icons.calendar_month_sharp,
                          size: 100.0,
                        ),
                        onPressed: () {
                          _navigateToScreen(const Agendar());
                        },
                      ),
                      const Text(
                        "Agendar",
                        style: TextStyle(fontSize: 17.0),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Card(
              margin: const EdgeInsets.all(10.0),
              child: InkWell(
                splashColor: Colors.blueGrey,
                onTap: () {
                  _navigateToScreen(const Medicos());
                },
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      IconButton(
                        icon: const Icon(
                          Icons.medical_services_sharp,
                          size: 100.0,
                        ),
                        onPressed: () {
                          _navigateToScreen(const Medicos());
                        },
                      ),
                      const Text(
                        "Médicos",
                        style: TextStyle(fontSize: 17.0),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Card(
              margin: const EdgeInsets.all(10.0),
              child: InkWell(
                splashColor: Colors.blueGrey,
                onTap: () {
                  _navigateToScreen(const Consultas());
                },
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      IconButton(
                        icon: const Icon(
                          Icons.info,
                          size: 100.0,
                        ),
                        onPressed: () {
                          _navigateToScreen(const Consultas());
                        },
                      ),
                      const Text(
                        "Consultas",
                        style: TextStyle(fontSize: 17.0),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex, // Para manter o estado da navegação
        onTap: _onNavBarTapped, // Alterar para o método correto
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Notificacaotela(),
            ),
          );
        },
        child: const Icon(
          Icons.notification_important,
          color: Colors.white,
        ),
        backgroundColor: Colors.indigo,
      ),
    );
  }
}
