import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Predefined admin credentials
  static const String adminEmail = 'admin@example.com';
  static const String adminPassword = 'admin123';

  Future<void> signUp(String email, String password, String phoneNumber) async {
    try {
      // Create the user
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Get the user ID
      String uid = userCredential.user!.uid;

      // Store the email and phone number in Firestore
      await _firestore.collection('users').doc(uid).set({
        'email': email,
        'phoneNumber': phoneNumber,
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future<User?> signIn(String email, String password) async {
    try {
      // Check for admin credentials
      if (email == adminEmail && password == adminPassword) {
        return null; // Return null or a custom admin User object
      }

      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Fetch user details
  Future<Map<String, dynamic>?> getUserDetails(String uid) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        return doc.data() as Map<String, dynamic>?;
      }
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

  // Update phone number
  Future<void> updatePhoneNumber(String uid, String newPhoneNumber) async {
    try {
      await _firestore.collection('users').doc(uid).update({
        'phoneNumber': newPhoneNumber,
      });
    } catch (e) {
      print(e.toString());
    }
  }

  // Admin features
  // Fetch all subjects for a semester
  Future<List<Map<String, dynamic>>> getSubjectsForSemester(
      String semester) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('semesters')
          .doc(semester)
          .collection('subjects')
          .get();
      return querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  // Add a new subject to a semester
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

  // Remove a subject from a semester
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

  // Add syllabus link to a subject
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
