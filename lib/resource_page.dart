import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ResourcePage extends StatelessWidget {
  final String semesterName;
  final String subjectName;

  ResourcePage({required this.semesterName, required this.subjectName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Resources for $subjectName'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('resources')
              .where('semesterId', isEqualTo: semesterName)
              .where('subjectId', isEqualTo: subjectName)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(child: Text('No resources available.'));
            }

            List<DocumentSnapshot> resources = snapshot.data!.docs;

            return ListView(
              children: [
                ...resources.map((doc) {
                  String link = doc['link'];
                  String type = doc['type'];
                  return ListTile(
                    title: Text('$type: $link'),
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
