import 'dart:async';
import 'package:agendamento/model/medico.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



class FirestoreService {
  //pega coleção
final CollectionReference medicos = 
FirebaseFirestore.instance.collection('Medicos');

Future<void> addMedico(Medico medico) {
  return medicos.add(medico.toFirebase());
}

//Pega as informações do banco 
Stream<QuerySnapshot> getMedicoStream() {
  final medicoStream =
  medicos.orderBy('timestamp', descending: true).snapshots();

  return medicoStream;

}

// Atualiza informação
Future<void> updateMedico(String docID, String novoNome, String novaEspecialidade) {
  return medicos.doc(docID).update({
    'nome': novoNome,
    'especialidade': novaEspecialidade,
    'timestamp': Timestamp.now(),
  });
}


// Deleta Informação
Future<void> deleteMedico(String docID) {
  return medicos.doc(docID).delete();

}

////////////////////////////////////////////////////////////////////////

final CollectionReference hospitais = 
FirebaseFirestore.instance.collection('Hospitais');

// Adiciona um novo médico ao banco de dados
Future<void> addHospital(String hospital) {

  return hospitais.add({
    'Nome': hospital,
    'timestamp': Timestamp.now(),

  });

}

//Pega as informações do banco 
Stream<QuerySnapshot> getHospitalStream() {
  final hospitalStream =
  hospitais.orderBy('timestamp', descending: true).snapshots();

  return hospitalStream;

}

// Atualiza informação
Future<void> updateHospital(String docID, String novoHospital){
  return hospitais.doc(docID).update({
  'Nome': novoHospital,
  'timestamp': Timestamp.now(),
  });

}

// Deleta Informação
Future<void> deleteHospital(String docID) {
  return hospitais.doc(docID).delete();

}


}