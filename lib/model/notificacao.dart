import 'package:cloud_firestore/cloud_firestore.dart';

class Notificacao {
  String? nome;
  String? data;
  String? hora;


  // Construtor
  Notificacao({
    this.nome,
    this.data,
    this.hora,
  });

  // Método para enviar dados para o Firebase
  Map<String, dynamic> toFirebase() {
    return {
      'nome': nome,
      'data': data,
      'hora': hora,

    };
  }

  // Construtor para criar um Agendamento a partir de dados do Firebase
  Notificacao.fromJson(Map<String, dynamic> json) {
    nome = json['nome'];
    data = json['data'];
    hora = json['hora'];

  }

  // Factory para criar um Agendamento a partir de um DocumentSnapshot do Firebase
  factory Notificacao.fromFirebase(DocumentSnapshot docnot) {
    final dados = docnot.data()! as Map<String, dynamic>;
    return Notificacao.fromJson(dados);
  }
}
