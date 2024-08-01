import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'models.dart';

class CourseSelectionPage extends StatefulWidget {
  @override
  _CourseSelectionPageState createState() => _CourseSelectionPageState();
}

class _CourseSelectionPageState extends State<CourseSelectionPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late Future<List<Course>> _courses;

  Future<List<Course>> _fetchCourses() async {
    final snapshot = await _firestore.collection('courses').get();
    return snapshot.docs.map((doc) => Course.fromFirestore(doc)).toList();
  }

  @override
  void initState() {
    super.initState();
    _courses = _fetchCourses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Course Selection')),
      body: FutureBuilder<List<Course>>(
        future: _courses,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No courses available.'));
          }

          final courses = snapshot.data!;

          return ListView.builder(
            itemCount: courses.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(courses[index].name),
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/semester',
                    arguments: courses[index].id,
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
