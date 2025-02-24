import 'dart:developer';

import 'package:agendamento/views/agendar.dart';
import 'package:agendamento/views/consultas.dart';
import 'package:agendamento/views/hometab.dart';
import 'package:agendamento/views/hospitais.dart';
import 'package:agendamento/views/medicos.dart';

import 'package:flutter/material.dart';

class Info extends StatefulWidget {
  const Info({super.key});

  @override
  State<Info> createState() => _InfoState();
}

class _InfoState extends State<Info> {
  String? _alergia;
  bool _alcool = false;
  bool _fumar = false;
  bool _exercicioT = false;
  bool _exercicioF = false;
  bool _ligadesliga = false;
  double _dor = 1;
  void _setAlergia(String? value) {
    setState(() {
      _alergia = value;
    });
  }
void _navigateToScreen(Widget telas) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => telas),
    );
  }
    void _enviarDados() {
      log("Alergia: $_alergia");
      log("Respostas: \nUso de Alcool: $_alcool \nFuma: $_fumar\nExercicio Frequente: $_exercicioT\nExercicio não frequente: $_exercicioF");
      log("Liga/Desliga:$_ligadesliga");
    }

  @override
  Widget build(BuildContext context) {
    
     return Scaffold(
      
     backgroundColor: Colors.blue[400],
   
      
      body: 
      
      SafeArea(
        
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
            
                const Text("Você possuí algum tipo de alergia?"),
                ListTile(
                  title: const Text("Sim"),
                  subtitle: const Text("Possuo alergias."),
                  leading: Radio<String>(
                    value: "sim",
                    groupValue: _alergia,
                    onChanged: _setAlergia,
                  ),
                  ),
                ListTile(
                  title: const Text("Não"),
                  subtitle: const Text("Não possuo nenhuma."),
                  leading: Radio<String>(
                    value: "nao",
                    groupValue: _alergia,
                    onChanged: _setAlergia,
                  ),
                  ),

                  const SizedBox(height: 20.0,),

                  const Text("Selecione uma ou mais das opções com a qual se identifica"),
                  CheckboxListTile(
                    title: const Text("Uso de Alcool"),
                    subtitle: const Text("Usa ou costuma ingerir bedidas alcoolicas"),
                    value: _alcool,
                   onChanged: (bool? value) {
                    setState(() {
                      _alcool = value!;
                    });
                   }),
                  CheckboxListTile(
                    title: const Text("Fumante"),
                    subtitle: const Text("Costume de fumar") ,
                    value: _fumar,
                   onChanged: (bool? value) {
                    setState(() {
                      _fumar = value!;
                    });
                   }),
                  CheckboxListTile(
                    title: const Text("Atividade Física"),
                    subtitle: const Text("Pratica atividade física regularmente."),
                    value: _exercicioT,
                   onChanged: (bool? value) {
                    setState(() {
                      _exercicioT = value!;
                    });
                   }),
                  CheckboxListTile(
                    title: const Text("Atividade Física não frequente"),
                    subtitle: const Text("Não pratica atividade física frequentemente."),
                    value: _exercicioF,
                   onChanged: (bool? value) {
                    setState(() {
                      _exercicioF = value!;
                    });
                   }),

                   const SizedBox(height: 20.0,),
                   const Text("Ligue e desligue"),
                   SwitchListTile(
                    title: const Text("Ligue e desligue!"),
                    value: _ligadesliga, 
                    onChanged: (bool value){
                      setState(() {
                        _ligadesliga = value;
                      });
                    }),
            const Text("Qual o nível de dor que está sentindo no momento?"),
                 Slider(value: _dor,
                      max: 10,
                      divisions: 10,
                      label: _dor.toString(),
                      activeColor: Colors.lightBlueAccent,
                      onChanged: (double value) {
                      setState(() {
                       _dor = value;
                      }
                    );
                  },
                ),
       
                    const SizedBox(height: 30.0,),
                    ElevatedButton(onPressed: _enviarDados, child: const Text("Enviar"),
                    ),
              ],
            ) ,
      ),
      ),
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