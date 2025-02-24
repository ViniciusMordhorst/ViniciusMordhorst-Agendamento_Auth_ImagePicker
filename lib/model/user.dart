import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String? uid; 
  String? nome;
  String? cpf;
  DateTime? dataNascimento;
  String? email;
  String? endereco;
  String? senha;
  String? foto;

  // Construtor
  User({
    this.uid,
    required this.nome,
    required this.cpf,
    required this.email,
    required this.senha,
    required this.dataNascimento,
    required this.endereco,
    this.foto,
  });

  // Método para converter um User em um Map (formato JSON) para salvar no Firestore
  Map<String, dynamic> toFirebase() {
    return {
      'uid': uid,
      'nome': nome,
      'cpf': cpf,
      'email': email,
      'senha': senha,
      'dataNascimento': dataNascimento,
      'endereco': endereco,
      'foto': foto,
    };
  }

  // Método para criar um User a partir de um mapa (JSON)
  User.fromJson(Map<String, dynamic> json)
      : uid = json['uid'],
        nome = json['nome'],
        cpf = json['cpf'],
        email = json['email'],
        senha = json['senha'],
        dataNascimento = (json['dataNascimento'] as Timestamp).toDate(),
        endereco = json['endereco'],
        foto = json['foto'];

  // Método de fábrica para criar um User a partir de um DocumentSnapshot
  static User fromFirebase(DocumentSnapshot doc) {
    final dados = doc.data()! as Map<String, dynamic>;
    return User.fromJson(dados);
  }
}
