import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminDashboardPage extends StatefulWidget {
  @override
  _AdminDashboardPageState createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  String? selectedSemester;
  String? selectedSubject;
  String? selectedResource;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _linkController = TextEditingController();

  Future<List<String>> _getSemesters() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('semesters').get();
    return querySnapshot.docs.map((doc) => doc['name'].toString()).toList();
  }

  Future<List<String>> _getSubjects(String semesterId) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('subjects')
        .where('semesterId', isEqualTo: semesterId)
        .get();
    return querySnapshot.docs.map((doc) => doc['name'].toString()).toList();
  }

  Future<List<String>> _getResources(String subjectId) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('resources')
        .where('subjectId', isEqualTo: subjectId)
        .get();
    return querySnapshot.docs.map((doc) => doc['type'].toString()).toList();
  }

  Future<List<String>> _getItems(String type) async {
    if (type == 'semester') {
      return _getSemesters();
    } else if (type == 'subject') {
      if (selectedSemester == null) return [];
      return _getSubjects(selectedSemester!);
    } else if (type == 'resource') {
      if (selectedSubject == null) return [];
      return _getResources(selectedSubject!);
    }
    return [];
  }

  void _addSemester() {
    FirebaseFirestore.instance
        .collection('semesters')
        .add({'name': _nameController.text});
    _nameController.clear();
  }

  void _addSubject(String semesterId) {
    FirebaseFirestore.instance
        .collection('subjects')
        .add({'name': _nameController.text, 'semesterId': semesterId});
    _nameController.clear();
  }

  void _addResource(String subjectId, String semesterId) {
    FirebaseFirestore.instance.collection('resources').add({
      'type': _nameController.text,
      'link': _linkController.text,
      'subjectId': subjectId,
      'semesterId': semesterId,
    });
    _nameController.clear();
    _linkController.clear();
  }

  void _removeSemester(String id) {
    FirebaseFirestore.instance.collection('semesters').doc(id).delete();
  }

  void _removeSubject(String id) {
    FirebaseFirestore.instance.collection('subjects').doc(id).delete();
  }

  void _removeResource(String id) {
    FirebaseFirestore.instance.collection('resources').doc(id).delete();
  }

  void _updateSemester(String id, String newName) {
    FirebaseFirestore.instance
        .collection('semesters')
        .doc(id)
        .update({'name': newName});
  }

  void _updateSubject(String id, String newName) {
    FirebaseFirestore.instance
        .collection('subjects')
        .doc(id)
        .update({'name': newName});
  }

  void _updateResource(String id, String newType, String newLink) {
    FirebaseFirestore.instance
        .collection('resources')
        .doc(id)
        .update({'type': newType, 'link': newLink});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Dashboard'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: FutureBuilder<List<String>>(
                future: _getSemesters(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return CircularProgressIndicator();
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Semesters',
                          style: Theme.of(context).textTheme.headlineMedium),
                      DropdownButton<String>(
                        value: selectedSemester,
                        hint: Text('Select Semester'),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedSemester = newValue;
                            selectedSubject = null;
                            selectedResource = null;
                          });
                        },
                        items: snapshot.data!
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                      TextButton(
                        onPressed: () {
                          _showAddDialog('semester');
                        },
                        child: Text('Add Semester'),
                      ),
                      TextButton(
                        onPressed: () {
                          _showRemoveDialog('semester');
                        },
                        child: Text('Remove Selected Semester'),
                      ),
                      if (selectedSemester != null)
                        Expanded(
                          child: FutureBuilder<List<String>>(
                            future: _getSubjects(selectedSemester!),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData)
                                return CircularProgressIndicator();
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Subjects',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineMedium),
                                  DropdownButton<String>(
                                    value: selectedSubject,
                                    hint: Text('Select Subject'),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        selectedSubject = newValue;
                                        selectedResource = null;
                                      });
                                    },
                                    items: snapshot.data!
                                        .map<DropdownMenuItem<String>>(
                                            (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      _showAddDialog(
                                          'subject', selectedSemester);
                                    },
                                    child: Text('Add Subject'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      _showRemoveDialog('subject');
                                    },
                                    child: Text('Remove Selected Subject'),
                                  ),
                                  if (selectedSubject != null)
                                    Expanded(
                                      child: FutureBuilder<List<String>>(
                                        future: _getResources(selectedSubject!),
                                        builder: (context, snapshot) {
                                          if (!snapshot.hasData)
                                            return CircularProgressIndicator();
                                          return Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text('Resources',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .headlineMedium),
                                              DropdownButton<String>(
                                                value: selectedResource,
                                                hint: Text('Select Resource'),
                                                onChanged: (String? newValue) {
                                                  setState(() {
                                                    selectedResource = newValue;
                                                  });
                                                },
                                                items: snapshot.data!.map<
                                                        DropdownMenuItem<
                                                            String>>(
                                                    (String value) {
                                                  return DropdownMenuItem<
                                                      String>(
                                                    value: value,
                                                    child: Text(value),
                                                  );
                                                }).toList(),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  _showAddDialog(
                                                      'resource',
                                                      selectedSubject,
                                                      selectedSemester);
                                                },
                                                child: Text('Add Resource'),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  _showRemoveDialog('resource');
                                                },
                                                child: Text(
                                                    'Remove Selected Resource'),
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                                    ),
                                ],
                              );
                            },
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddDialog(String type, [String? parentId, String? semesterId]) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add $type'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              if (type == 'resource')
                TextField(
                  controller: _linkController,
                  decoration: InputDecoration(labelText: 'Link'),
                ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                if (type == 'semester') {
                  _addSemester();
                } else if (type == 'subject') {
                  if (parentId != null) _addSubject(parentId);
                } else if (type == 'resource') {
                  if (parentId != null && semesterId != null) {
                    _addResource(parentId, semesterId);
                  }
                }
              },
              child: Text('Add'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _showRemoveDialog(String type) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Remove $type'),
          content: FutureBuilder<List<String>>(
            future: _getItems(type),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return CircularProgressIndicator();
              return DropdownButton<String>(
                value: type == 'semester'
                    ? selectedSemester
                    : type == 'subject'
                        ? selectedSubject
                        : selectedResource,
                hint: Text('Select $type to remove'),
                onChanged: (String? newValue) {
                  setState(() {
                    if (type == 'semester') {
                      selectedSemester = newValue;
                      selectedSubject = null; // Reset subject and resource
                      selectedResource = null;
                    } else if (type == 'subject') {
                      selectedSubject = newValue;
                      selectedResource = null; // Reset resource
                    } else if (type == 'resource') {
                      selectedResource = newValue;
                    }
                  });
                },
                items: snapshot.data!
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                if (type == 'semester' && selectedSemester != null) {
                  _removeSemester(selectedSemester!);
                } else if (type == 'subject' && selectedSubject != null) {
                  _removeSubject(selectedSubject!);
                } else if (type == 'resource' && selectedResource != null) {
                  _removeResource(selectedResource!);
                }
              },
              child: Text('Remove'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}
