import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:prominent/firebase/auth.dart';
import 'package:prominent/models/project.dart';
import 'package:uuid/uuid.dart';

class RegisterActivity extends StatefulWidget {
  const RegisterActivity({Key? key, required this.project}) : super(key: key);

  final Project project;

  @override
  _RegisterActivityState createState() => _RegisterActivityState();
}

class _RegisterActivityState extends State<RegisterActivity> {
  final TextEditingController actTitleController = TextEditingController();
  final TextEditingController actDescriptionController = TextEditingController();
  late DateTime startDate = DateTime.now();
  late DateTime endDate = DateTime.now();
  late String strStrDate;
  late String strEndDate;
  TextEditingController statusController = TextEditingController();
  String selectedStatus = 'New';
  final _formKey = GlobalKey<FormState>();
  final List<String> statusList = ['New', 'On Hold', 'In Progress', 'Completed'];

  void _startDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    ).then((pickedDate) {
      if (pickedDate == null) return;

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
      lastDate: DateTime(2100),
    ).then((pickedDate) {
      if (pickedDate == null) return;

      setState(() {
        endDate = pickedDate;
      });
    });
  }

  Future<void> addActivity(
    String title,
    String description,
    String strStrdate,
    String strEndDate,
    String status,
    Project project,
  ) async {
    CollectionReference activities =
        FirebaseFirestore.instance.collection('activities');

    String documentID = const Uuid().v4();

    activities
        .doc(documentID)
        .set({
          'document ID': documentID,
          'user': Auth().currentUser?.uid,
          'project': project.title,
          'activity title': title,
          'activity description': description,
          'start date': strStrdate,
          'end date': strEndDate,
          'status': status,
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
      appBar: AppBar(
        title: const Text('Register Activity'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextFormField(
                controller: actTitleController,
                decoration: InputDecoration(
                  labelText: 'Activity Title',
                  hintText: 'Enter the activity title',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Required!';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: actDescriptionController,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  labelText: 'Activity Description',
                  hintText: 'Talk a little about the activity',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Required!';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildDateInputField(
                      label: 'Start Date',
                      date: startDate,
                      onTap: _startDatePicker,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildDateInputField(
                      label: 'End Date',
                      date: endDate,
                      onTap: _endDatePicker,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildStatusInputField(),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    addActivity(
                      actTitleController.text,
                      actDescriptionController.text,
                      DateFormat.yMd().format(startDate),
                      DateFormat.yMd().format(endDate),
                      selectedStatus,
                      project,
                    );

                    Navigator.of(context).pop();
                  }
                },
                child: const Text('Register Activity'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateInputField({
    required String label,
    required DateTime date,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_today),
            const SizedBox(width: 8),
            Text(
              date == null ? 'No Date Chosen' : DateFormat.yMd().format(date),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusInputField() {
    return InkWell(
      onTap: () {
        _showStatusPicker();
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: 'Current Status',
        ),
        child: Row(
          children: [
            const Icon(Icons.arrow_drop_down),
            const SizedBox(width: 8),
            Text(selectedStatus),
          ],
        ),
      ),
    );
  }

  void _showStatusPicker() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Container(
            height: 200,
            child: ListView.builder(
              itemCount: statusList.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(statusList[index]),
                  onTap: () {
                    setState(() {
                      selectedStatus = statusList[index];
                      statusController.text = selectedStatus;
                    });
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }
}
