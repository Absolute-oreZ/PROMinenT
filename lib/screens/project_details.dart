import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:prominent/firebase/auth.dart';
import 'package:prominent/models/activity.dart';
import 'package:prominent/models/project.dart';
import 'package:prominent/screens/register_activity.dart';
import 'package:prominent/screens/task_timeline_tile.dart';

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
      var currentUser = Auth().currentUser;

      if (currentUser != null) {
        // Check if the current user is an admin
        bool isAdmin = currentUser.email?.contains("admin") ?? false;

        var data;
        if (isAdmin) {
          // If admin, fetch all activities
          data = await FirebaseFirestore.instance
              .collection("activities")
              .where('project', isEqualTo: selectedProject.title)
              .get();
        } else {
          // If not admin, fetch activities for the current user
          data = await FirebaseFirestore.instance
              .collection("activities")
              .where('user', isEqualTo: currentUser.uid)
              .where('project', isEqualTo: selectedProject.title)
              .get();
        }

        for (var doc in data.docs) {
          Activity act = Activity(
            docID: doc.id,
            taskTitle: doc.data()['activity title'],
            taskDesc: doc.data()['activity description'],
            start: doc.data()['start date'],
            end: doc.data()['end date'],
            status: doc.data()['status'],
          );
          loadedActivities.add(act);
        }
      }

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
    setState(() {
      fetchActivities();
    });
    return Scaffold(
      body: Container(
        height: 800,
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
            const SizedBox(height: 30,),
            //display a list of activities
            Expanded(
                child: selectedProject.activities.isEmpty
                    ? Center(
                        child: Text(
                          'No activities yet!',
                          style: Theme.of(context).textTheme.displayLarge,
                        ),
                      )
                    : SizedBox(
                        height: 40,
                        child: ListView.builder(
                          itemCount: selectedProject.activities.length,
                          itemBuilder: (context, index) {
                            return TaskTimelineTile(
                              isFirst: index == 0 ? true : false,
                              isLast:
                                  index == selectedProject.activities.length - 1
                                      ? true
                                      : false,
                              isPast:
                                  selectedProject.activities[index].status ==
                                          'Completed'
                                      ? true
                                      : false,
                              act: selectedProject.activities[index],
                            );
                          },
                        ),
                      ))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) =>
                  RegisterActivity(project: selectedProject)));
        },
        tooltip: 'Add New Activity',
        child: const Icon(
          Icons.add,
          size: 30,
        ),
      ),
    );
  }
}
