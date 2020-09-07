import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String id;
  final int age;
  final String country;
  final String email;
  final String photoUrl;
  final String displayName;
  final String bio;
  final String category;

  User({
    this.id,
    this.age,
    this.country,
    this.email,
    this.photoUrl,
    this.displayName,
    this.bio,
    this.category,
  });

  factory User.fromDocument(DocumentSnapshot doc) {
    return User(
      id: doc['id'],
      email: doc['email'],
      age: doc['age'],
      country: doc['country'],
      photoUrl: doc['photoUrl'],
      displayName: doc['displayName'],
      bio: doc['bio'],
      category: doc['category'],
    );
  }
}
