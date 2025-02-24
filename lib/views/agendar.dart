import 'dart:developer';
import 'package:agendamento/controller/agendamentoDBController.dart';
import 'package:agendamento/controller/notificacaodb.dart';
import 'package:agendamento/model/agendamento.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

const List<String> horas = <String>[
  '00', '01', '02', '03', '04', '05', '06', '07', '08', '09', '10',
  '11', '12', '13', '14', '15', '16', '17', '18', '19', '20', '21',
  '22', '23'
];

const List<String> minutos = <String>[
  '00', '01', '02', '03', '04', '05', '06', '07', '08', '09', '10',
  '11', '12', '13', '14', '15', '16', '17', '18', '19', '20', '21',
  '22', '23', '24', '25', '26', '27', '28', '29', '30', '45'
];

const List<String> tiposDeConsulta = ['Consulta Geral', 'Pediatria', 'Dermatologia', 'Cardiologia'];

class Agendar extends StatefulWidget {
  const Agendar({super.key});

  @override
  State<Agendar> createState() => _AgendarState();
}

class _AgendarState extends State<Agendar> {
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _telefoneController = TextEditingController();
  final TextEditingController _calendarioController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? _hora;
  String? _minuto;
  String? _tipoConsulta;

  void _enviarDados() {
    if (_formKey.currentState?.validate() ?? false) {
final agendamento = Agendamento(
  nome: _nomeController.text,
  telefone: _telefoneController.text,
  data: _calendarioController.text,
  hora: '$_hora:$_minuto',
  tipo: _tipoConsulta ?? '',

);


      final agendamentodb = AgendamentoDBController();

      agendamentodb.adicionarAgendamento(agendamento).then((_) {
        log("Agendamento salvo com sucesso!");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Consulta agendada com sucesso!"))
        );

        // Salva a notificação após o agendamento ser concluído
    final notificacaoDB = NotificacaoDB(); // Instancia a classe NotificacaoDB
      notificacaoDB.salvarNotificacao(
      _nomeController.text,
      _calendarioController.text,
      '$_hora:$_minuto'
    ).then((_) {
      log("Notificação salva com sucesso!");
    }).catchError((error) {
  log("Erro ao salvar notificação: $error");
});




        _formKey.currentState?.reset();
      }).catchError((error) {
        log("Erro ao salvar agendamento: $error");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Erro ao agendar consulta"))
        );
      });
    }
  }

  Future<void> _Calendario(BuildContext context) async {
    final DateTime? data = await showDatePicker(
      context: context,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      currentDate: DateTime.now(),
    );
    if (data != null) {
      setState(() {
        _calendarioController.text = DateFormat("dd/MM/yyyy").format(data);
      });
    }
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _telefoneController.dispose();
    _calendarioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[400],
      appBar: AppBar(
        title: const Text("Agendar Consulta"),
        backgroundColor: Colors.blue[400],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _nomeController,
                  decoration: const InputDecoration(
                    hintText: 'Nome',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value == null || value.isEmpty ? 'Campo é obrigatório' : null,
                ),
                const SizedBox(height: 20.0),
                TextFormField(
                  controller: _telefoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    hintText: 'Telefone',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value == null || value.isEmpty ? 'Campo é obrigatório' : null,
                ),
                const SizedBox(height: 20.0),
                TextFormField(
                  controller: _calendarioController,
                  keyboardType: TextInputType.datetime,
                  decoration: InputDecoration(
                    hintText: 'Digite/selecione a data da consulta',
                    filled: true,
                    fillColor: Colors.white,
                    border: const OutlineInputBorder(),
                    suffixIcon: GestureDetector(
                      child: Icon(Icons.calendar_month, color: Colors.blue[600]),
                      onTap: () => _Calendario(context),
                    ),
                  ),
                  validator: (value) => value == null || value.isEmpty ? 'Campo é obrigatório' : null,
                ),
                const SizedBox(height: 20.0),
                const Text('Selecione um horário'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    DropdownButton<String>(
                      value: _hora,
                      hint: const Text('Hora'),
                      items: horas.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? value) {
                        setState(() {
                          _hora = value;
                        });
                      },
                    ),
                    const SizedBox(width: 8),
                    const Text(':'),
                    const SizedBox(width: 8),
                    DropdownButton<String>(
                      value: _minuto,
                      hint: const Text('Minuto'),
                      items: minutos.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? value) {
                        setState(() {
                          _minuto = value;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text('Selecione o tipo de consulta'),
                DropdownButton<String>(
                  value: _tipoConsulta,
                  hint: const Text('Selecione'),
                  items: tiposDeConsulta.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? value) {
                    setState(() {
                      _tipoConsulta = value;
                    });
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _enviarDados,
                  child: const Text("Enviar"),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
