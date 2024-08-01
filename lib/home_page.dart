import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(
              context,
              '/semester',
              arguments: 'some_course_id', // Replace with actual course ID
            );
          },
          child: Text('Select Semester'),
        ),
      ),
    );
  }
}
