import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SemesterSelectionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Semester'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StreamBuilder<QuerySnapshot>(
          stream:
              FirebaseFirestore.instance.collection('semesters').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(child: Text('No semesters available.'));
            }

            List<DocumentSnapshot> semesters = snapshot.data!.docs;

            return ListView(
              children: [
                ...semesters.map((doc) {
                  String semesterName = doc['name'];
                  return ListTile(
                    title: Text(semesterName),
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/subject',
                        arguments:
                            semesterName, // Pass the semester name as argument
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
