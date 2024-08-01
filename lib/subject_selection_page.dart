import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SubjectSelectionPage extends StatelessWidget {
  final String semesterName;

  SubjectSelectionPage({required this.semesterName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Subject'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('subjects')
              .where('semesterId', isEqualTo: semesterName)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(child: Text('No subjects available.'));
            }

            List<DocumentSnapshot> subjects = snapshot.data!.docs;

            return ListView(
              children: [
                ...subjects.map((doc) {
                  String subjectName = doc['name'];
                  return ListTile(
                    title: Text(subjectName),
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/resources',
                        arguments: {
                          'semesterName': semesterName,
                          'subjectName': subjectName,
                        },
                      );
                    },
                  );
                }).toList(),
              ],
            );
          },
        ),
      ),
    );
  }
}
