import 'package:cloud_firestore/cloud_firestore.dart';

class Course {
  final String id;
  final String name;

  Course({required this.id, required this.name});

  factory Course.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Course(
      id: doc.id,
      name: data['name'] ?? '',
    );
  }
}

class Semester {
  final String id;
  final String name;

  Semester({required this.id, required this.name});

  factory Semester.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Semester(
      id: doc.id,
      name: data['name'] ?? '',
    );
  }
}

class Subject {
  final String id;
  final String name;

  Subject({required this.id, required this.name});

  factory Subject.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Subject(
      id: doc.id,
      name: data['name'] ?? '',
    );
  }
}
