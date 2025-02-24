import 'package:cloud_firestore/cloud_firestore.dart';

class Medico {
  String? nome;
  String? especialidade;

  // Construtor da classe Medico
  Medico(this.nome, this.especialidade);

  // Converte o objeto Medico para um formato que o Firestore entende
  Map<String, dynamic> toFirebase() {
    return {
      'nome': nome,
      'especialidade': especialidade,
      'timestamp': Timestamp.now(), // Adiciona a data/hora de criação
    };
  }

  // Construtor a partir de um mapa de dados (JSON)
  Medico.fromJson(Map<String, dynamic> json) {
    nome = json['nome'];
    especialidade = json['especialidade'];
  }

  // Constrói um objeto Medico a partir de um DocumentSnapshot
  factory Medico.fromFirebase(DocumentSnapshot doc) {
    final dados = doc.data()! as Map<String, dynamic>;
    return Medico.fromJson(dados);
  }
}
