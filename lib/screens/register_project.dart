import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:prominent/firebase/auth.dart';
import 'package:prominent/screens/homepage.dart';
import 'package:uuid/uuid.dart';

class RegisterProject extends StatefulWidget {
  const RegisterProject({Key? key}) : super(key: key);

  @override
  _RegisterProjectState createState() => _RegisterProjectState();
}

class _RegisterProjectState extends State<RegisterProject> {
  final projectTitleController = TextEditingController();
  final projectDescriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<void> addProject(String title, String description) async {
    CollectionReference projects =
        FirebaseFirestore.instance.collection('projects');

    String projectId = const Uuid().v4(); // Generate a unique ID

    projects
        .doc(projectId)
        .set({
          'project_id': projectId, // Save the project ID
          'user': Auth().currentUser?.uid,
          'title': title,
          'description': description,
        })
        .then((value) => print("Project added successfully!"))
        .catchError((error) => print("Failed to add project: $error"));
  }

  @override
  void dispose() {
    projectTitleController.dispose();
    projectDescriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Image.asset(
                "assets/images/PROMinenT Logo.png",
                width: 200,
              ),
              const SizedBox(
                height: 40,
              ),
              TextFormField(
                controller: projectTitleController,
                cursorColor: Colors.white,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  icon: const Icon(
                    Icons.title,
                    size: 30,
                    color: Colors.white,
                  ),
                  labelText: 'Project Title',
                  labelStyle: Theme.of(context).textTheme.bodyMedium,
                  hintText: 'Enter the proejct title',
                  hintStyle: Theme.of(context).textTheme.bodyMedium,
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      width: 1,
                      color: Color.fromRGBO(206, 212, 221, 1),
                      style: BorderStyle.solid,
                    ),
                    borderRadius: BorderRadius.circular(40),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    const TextStyle(
                        color: Colors.red, fontWeight: FontWeight.bold);
                    return 'Required!';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                  controller: projectDescriptionController,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  cursorColor: Colors.white,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    icon: const Icon(
                      Icons.description,
                      size: 30,
                      color: Colors.white,
                    ),
                    labelText: 'Project Description',
                    labelStyle: Theme.of(context).textTheme.bodyMedium,
                    hintText: 'Talk a little about the project',
                    hintStyle: Theme.of(context).textTheme.bodyMedium,
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        width: 1,
                        color: Color.fromRGBO(206, 212, 221, 1),
                        style: BorderStyle.solid,
                      ),
                      borderRadius: BorderRadius.circular(40),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      const TextStyle(
                          color: Colors.red, fontWeight: FontWeight.bold);
                      return 'Required!';
                    }
                    return null;
                  }),
              const SizedBox(
                height: 30,
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                ),
                icon: const Icon(
                  Icons.save,
                  color: Colors.white,
                  size: 30,
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    addProject(projectTitleController.text,
                        projectDescriptionController.text);

                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return HomePage();
                    }));
                  }
                },
                label: const Text(
                  'Register Project',
                  style: TextStyle(color: Colors.white),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
