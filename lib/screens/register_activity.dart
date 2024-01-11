import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:prominent/firebase/auth.dart';
import 'package:prominent/models/project.dart';

class RegisterActivity extends StatefulWidget {
  const RegisterActivity({super.key, required this.project});

  final Project project;

  @override
  _RegisterActivityState createState() => _RegisterActivityState();
}

class _RegisterActivityState extends State<RegisterActivity> {
  final actTitleController = TextEditingController();
  final actDescriptionController = TextEditingController();
  late DateTime startDate = DateTime.now();
  late DateTime endDate = DateTime.now();
  late String strStrDate;
  late String strEndDate;
  final statusController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _startDatePicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime.now(),
            lastDate: DateTime(2100))
        .then((pickedDate) {
      if (pickedDate == null) {
        return;
      }

      setState(() {
        startDate = pickedDate;
      });
    });
  }

  void _endDatePicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime.now(),
            lastDate: DateTime(2100))
        .then((pickedDate) {
      if (pickedDate == null) {
        return;
      }

      setState(() {
        endDate = pickedDate;
      });
    });
  }

  Future<void> addActivity(String title, String description, String strStrdate,
      String strEndDate, String status, Project project) {
    CollectionReference activities =
        FirebaseFirestore.instance.collection('activities');

    return activities
        .add({
          'user': Auth().currentUser?.uid,
          'project': project.title,
          'activity title': title,
          'activity description': description,
          'start date': strStrdate,
          'end date': strEndDate,
          'status': status
        })
        .then((value) => print("Activity added successfully!"))
        .catchError((error) => print("Failed to add activity: $error"));
  }

  @override
  void dispose() {
    actTitleController.dispose();
    actDescriptionController.dispose();
    statusController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Project project = widget.project;
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(
                height: 40,
              ),
              TextFormField(
                controller: actTitleController,
                cursorColor: Colors.white,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  icon: const Icon(
                    Icons.title,
                    size: 30,
                    color: Colors.white,
                  ),
                  labelText: 'Activity Title',
                  labelStyle: Theme.of(context).textTheme.bodyMedium,
                  hintText: 'Enter the activity title',
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
                  controller: actDescriptionController,
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
                    labelText: 'Activity Description',
                    labelStyle: Theme.of(context).textTheme.bodyMedium,
                    hintText: 'Talk a little about the activity',
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
              SizedBox(
                height: 90,
                child: Column(
                  children: [
                    const Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          color: Colors.white60,
                          size: 30,
                        ),
                        SizedBox(
                          width: 30,
                        ),
                        Text(
                          "Enter the start date of the activity:",
                          style: TextStyle(
                              color: Colors.white60,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            startDate == null
                                ? 'No Date Chosen'
                                : 'Picked Date: ${DateFormat.yMd().format(startDate)}',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        TextButton(
                            onPressed: _startDatePicker,
                            child: const Text(
                              "Choose Start Date",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ))
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 90,
                child: Column(
                  children: [
                    const Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          color: Colors.white60,
                          size: 30,
                        ),
                        SizedBox(
                          width: 30,
                        ),
                        Text(
                          "Enter the end date of the activity:",
                          style: TextStyle(
                              color: Colors.white60,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            endDate == null
                                ? 'No Date Chosen'
                                : 'End Date: ${DateFormat.yMd().format(endDate)}',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        TextButton(
                            onPressed: _endDatePicker,
                            child: const Text(
                              "Choose End Date",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ))
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: statusController,
                cursorColor: Colors.white,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  icon: const Icon(
                    Icons.title,
                    size: 30,
                    color: Colors.white,
                  ),
                  labelText: 'Activity Status',
                  labelStyle: Theme.of(context).textTheme.bodyMedium,
                  hintText: 'choose the current status of the activity',
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
                    addActivity(
                        actTitleController.text,
                        actDescriptionController.text,
                        DateFormat.yMd().format(startDate),
                        DateFormat.yMd().format(endDate),
                        statusController.text,
                        project);

                    Navigator.of(context).pop();
                  }
                },
                label: const Text(
                  'Register Activity',
                  style: TextStyle(color: Color.fromRGBO(255, 255, 255, 1)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
