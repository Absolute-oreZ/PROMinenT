import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:prominent/firebase/auth.dart';
import 'package:prominent/models/activity.dart';
import 'package:prominent/models/project.dart';
import 'package:prominent/screens/register_activity.dart';

class ProjectDetail extends StatefulWidget {
  const ProjectDetail({
    super.key,
    required this.selectedProject,
  });

  final Project selectedProject;

  @override
  _ProjectDetail createState() => _ProjectDetail();
}

class _ProjectDetail extends State<ProjectDetail> {
  var _isLoading = true;
  Future<void> fetchActivities() async {
    Project selectedProject = widget.selectedProject;
    List<Activity> loadedActivities = [];
    try {
      var data =
          await FirebaseFirestore.instance.collection("activities").get();
      for (int i = 0; i < data.docs.length; i++) {
        // Check if the fetched activity is related to the selected project
        if (data.docs[i].data()['user'] == Auth().currentUser?.uid &&
            data.docs[i].data()['project'] == selectedProject.title) {
          Activity act = Activity(
            taskTitle: data.docs[i].data()['activity title'],
            taskDesc: data.docs[i].data()['activity description'],
            start: data.docs[i].data()['start date'],
            end: data.docs[i].data()['end date'],
            status: data.docs[i].data()['status'],
          );
          loadedActivities.add(act);
        }
      }

      // Update the selected project's activities directly
      setState(() {
        selectedProject.activities = loadedActivities;
        _isLoading = false;
      });
    } catch (error) {
      print("Error fetching project list: $error");
    }
  }

  @override
  void initState() {
    super.initState();
    fetchActivities();
  }

  @override
  Widget build(BuildContext context) {
    Project selectedProject = widget.selectedProject;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              selectedProject.title,
              style: Theme.of(context).textTheme.displayLarge,
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              selectedProject.description,
              style: Theme.of(context).textTheme.displayMedium,
            ),
            const SizedBox(
              height: 20,
            ),
            //display a list of activities
            Expanded(
              child: selectedProject.activities.isEmpty
                  ? Center(
                      child: Text(
                        'No activities yet!',
                        style: Theme.of(context).textTheme.displayLarge,
                      ),
                    )
                  : ListView.builder(
                      itemCount: selectedProject.activities.length,
                      itemBuilder: (context, index) {
                        var activity = selectedProject.activities[index];
                        return ListTile(
                          title: Text(activity.taskTitle),
                          subtitle: Text(activity.taskDesc),
                        );
                      },
                    ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) =>
                  RegisterActivity(project: selectedProject)));
        },
        child: const Icon(
          Icons.add,
          size: 30,
        ),
      ),
    );
  }
}
