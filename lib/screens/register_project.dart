import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterProject extends StatefulWidget {
  const RegisterProject({Key? key}) : super(key: key);

  @override
  _RegisterProjectState createState() => _RegisterProjectState();
}

class _RegisterProjectState extends State<RegisterProject> {
  Future<void> addProejct(
      String title, String description, Timeline projectTimeLine, int age) {
    CollectionReference projects =
        FirebaseFirestore.instance.collection('projects');

    return projects
        .add({
          'title': title,
          'description': description,
          'projectTimeLine': projectTimeLine,
        })
        .then((value) => print("User added successfully!"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text("Hello"),),
    );
  }
}
