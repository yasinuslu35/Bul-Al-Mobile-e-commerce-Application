import 'package:cloud_firestore/cloud_firestore.dart';

class KumandaModel {
  final String name;

  KumandaModel({required this.name});

  factory KumandaModel.fromDocument(DocumentSnapshot doc) {
    return KumandaModel(
      name: doc['Title'],
    );
  }
}