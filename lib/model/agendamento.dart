import 'package:cloud_firestore/cloud_firestore.dart';

class Agendamento {
  String? id; // ID do documento no Firestore
  String? userId; // ID do usuário que fez o agendamento
  String? nome;
  String? telefone;
  String? data;
  String? hora;
  String? tipo;

  // Construtor
  Agendamento({
    this.id,
    this.userId,
    this.nome,
    this.telefone,
    this.data,
    this.hora,
    this.tipo,
  });

  // Método para enviar dados para o Firebase
  Map<String, dynamic> toFirebase() {
    return {
      'userId': userId, // Associando o agendamento ao usuário
      'nome': nome,
      'telefone': telefone,
      'data': data,
      'hora': hora,
      'tipo': tipo,
    };
  }

  // Construtor para criar um Agendamento a partir de dados do Firebase
  Agendamento.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId']; // Recuperando o ID do usuário
    nome = json['nome'];
    telefone = json['telefone'];
    data = json['data'];
    hora = json['hora'];
    tipo = json['tipo'];
  }

  // Factory para criar um Agendamento a partir de um DocumentSnapshot do Firebase
  factory Agendamento.fromFirebase(DocumentSnapshot doc) {
    final dados = doc.data()! as Map<String, dynamic>;
    return Agendamento(
      id: doc.id, // Pegando o ID gerado pelo Firestore
      userId: dados['userId'], // Pegando o ID do usuário do documento
      nome: dados['nome'],
      telefone: dados['telefone'],
      data: dados['data'],
      hora: dados['hora'],
      tipo: dados['tipo'],
    );
  }
}
