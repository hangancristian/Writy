import 'package:cloud_firestore/cloud_firestore.dart';

class Data {
  int age;
  String country;
  String category;

  Data({this.age, this.country, this.category});
  factory Data.fromDocument(DocumentSnapshot doc) {
    return Data(
      age: doc['age'],
      country: doc['country'],
      category: doc['category'],
    );
  }
}
