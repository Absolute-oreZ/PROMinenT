import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:prominent/models/activity.dart';

class EditActivity extends StatefulWidget {
  const EditActivity({Key? key, required this.act}) : super(key: key);

  final Activity act;

  @override
  _EditActivityState createState() => _EditActivityState();
}

class _EditActivityState extends State<EditActivity> {
  late TextEditingController actTitleController;
  late TextEditingController actDescriptionController;
  late TextEditingController statusController;
  late DateTime startDate = DateTime.now();
  late DateTime endDate = DateTime.now();
  final _formKey = GlobalKey<FormState>();
  String status = 'New';
  final List<String> statusList = [
    'New',
    'On Hold',
    'In Progress',
    'Completed'
  ];

  Future<void> updateActivityDetail(
    String documentID,
    String newTitle,
    String newDescription,
    String newStrStrdate,
    String newStrEndDate,
    String newStatus,
  ) async {
    CollectionReference activities =
        FirebaseFirestore.instance.collection('activities');

    // Check if the activity ID exists in the Firestore database
    DocumentSnapshot doc = await activities.doc(documentID).get();
    if (doc.exists) {
      // If the activity ID exists, update the fields in the document
      return activities
          .doc(documentID)
          .update({
            'activity title': newTitle,
            'activity description': newDescription,
            'start date': newStrStrdate,
            'end date': newStrEndDate,
            'status': newStatus
          })
          .then((value) => print("Activity updated successfully!"))
          .catchError((error) => print("Failed to update activity: $error"));
    } else {
      // If the activity ID doesn't exist, log an error message
      print(
          "Failed to update activity: The specified activity ID $documentID dont exist in the Firestore database.");
    }
  }

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

  @override
  void dispose() {
    actTitleController.dispose();
    actDescriptionController.dispose();
    statusController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    Activity act = widget.act;
    super.initState();
    actTitleController = TextEditingController(text: act.taskTitle);
    actDescriptionController = TextEditingController(text: act.taskDesc);
    statusController = TextEditingController(text: act.status);
  }

  @override
  Widget build(BuildContext context) {
    Activity selectedAct = widget.act;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Activity'),
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
                    updateActivityDetail(
                      selectedAct.docID,
                      actTitleController.text,
                      actDescriptionController.text,
                      DateFormat.yMd().format(startDate),
                      DateFormat.yMd().format(endDate),
                      status,
                    );

                    Navigator.of(context).pop();
                  }
                },
                child: const Text('Edit Activity'),
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
            Text(status),
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
                      status = statusList[index];
                      statusController.text = status;
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
