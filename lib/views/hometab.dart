import 'package:agendamento/views/Consultas.dart';
import 'package:agendamento/views/info.dart';
import 'package:agendamento/views/profile.dart';
import 'package:flutter/material.dart';

class Hometab extends StatefulWidget {
  const Hometab({super.key});

  @override
  State<Hometab> createState() => _HometabState();
}

class _HometabState extends State<Hometab> {

  

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(length: 2, child: Scaffold(
      appBar: AppBar(
        title: Text('Perfil'),
         backgroundColor: Colors.blue[400],
        bottom: TabBar(
        indicatorColor: Colors.blueGrey[100], 
        dividerColor: Colors.green,
        labelColor: Colors.white,
        unselectedLabelColor: Colors.blue[900],
          tabs: [
         Tab(
            text: 'Profile',
            icon:Icon(Icons.person)
          ),
          Tab(
            text: 'Informações',
            icon:Icon(Icons.info)
          ),
       
        ]),
      ),
      body: const TabBarView(children: [
        Profile(),
        Info(),
       
      ],
      ),
    ),

   
    );
    
  }
}