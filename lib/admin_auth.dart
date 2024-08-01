import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Predefined admin credentials
  static const String adminEmail = 'admin@example.com';
  static const String adminPassword = 'admin123';

  // Admin login
  Future<User?> adminSignIn(String email, String password) async {
    if (email == adminEmail && password == adminPassword) {
      // Return a fake user object or a custom admin object
      return await _auth
          .signInWithEmailAndPassword(
            email: adminEmail,
            password: adminPassword,
          )
          .then((userCredential) => userCredential.user);
    } else {
      // Invalid credentials
      return null;
    }
  }

  // Admin features
  Future<void> addSubjectToSemester(String semester, String subjectName) async {
    try {
      await _firestore
          .collection('semesters')
          .doc(semester)
          .collection('subjects')
          .add({
        'name': subjectName,
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> removeSubjectFromSemester(
      String semester, String subjectId) async {
    try {
      await _firestore
          .collection('semesters')
          .doc(semester)
          .collection('subjects')
          .doc(subjectId)
          .delete();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> addSyllabusLink(
      String semester, String subjectId, String link) async {
    try {
      await _firestore
          .collection('semesters')
          .doc(semester)
          .collection('subjects')
          .doc(subjectId)
          .update({
        'syllabus': link,
      });
    } catch (e) {
      print(e.toString());
    }
  }
}
