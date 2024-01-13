import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:prominent/firebase/auth.dart';
import 'package:prominent/models/activity.dart';
import 'package:prominent/models/project.dart';
import 'package:prominent/screens/project_details.dart';

class ProjecList extends StatefulWidget {
  const ProjecList({Key? key}) : super(key: key);

  @override
  _ProjectListState createState() => _ProjectListState();
}

class _ProjectListState extends State<ProjecList> {
  var _isLoading = true;

  // Load items from Cloud Firestore
  List<Project> _projects = [];

  Future<void> fetchProjectList() async {
    List<Project> loadedProjects = [];
    try {
      var currentUser = Auth().currentUser;

      if (currentUser != null) {
        bool isAdmin = currentUser.email?.contains("admin") ?? false;

        var data;
        if (isAdmin) {
          // If admin, fetch all projects
          data = await FirebaseFirestore.instance.collection("projects").get();
        } else {
          // If not admin, fetch projects for the current user
          data = await FirebaseFirestore.instance
              .collection("projects")
              .where('user', isEqualTo: currentUser.uid)
              .get();
        }

        for (int i = 0; i < data.docs.length; i++) {
          Project project = Project(
            projectId: data.docs[i].id,
            title: data.docs[i].data()?['title'] ?? '',
            description: data.docs[i].data()?['description'] ?? '',
          );

          // Fetch activities for each project
          var activitiesData = await FirebaseFirestore.instance
              .collection("activities")
              .where('project', isEqualTo: project.title)
              .get();

          for (var activityDoc in activitiesData.docs) {
            Activity activity = Activity(
              docID: activityDoc.id,
              taskTitle: activityDoc.data()?['activity title'] ?? '',
              taskDesc: activityDoc.data()?['activity description'] ?? '',
              start: activityDoc.data()?['start date'] ?? '',
              end: activityDoc.data()?['end date'] ?? '',
              status: activityDoc.data()?['status'] ?? '',
            );

            project.activities.add(activity);
          }

          // Calculate progression after loading activities
          project.calculateProgression();

          loadedProjects.add(project);
        }
      }

      setState(() {
        _projects = loadedProjects;
        _isLoading = false;
      });
    } catch (error) {
      print("Error fetching project list: $error");
    }
  }

  @override
  void initState() {
    super.initState();
    fetchProjectList();
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      fetchProjectList();
    });
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _projects.isEmpty
              ? Center(
                  child: Row(
                    children: [
                      const Text('No project added yet.'),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          elevation: 5,
                          primary: Colors.blue[800],
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: Text('Add One!', style: TextStyle(fontSize: 16)),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: _projects.length,
                  itemBuilder: (context, index) {
                    int progress = _projects[index].calculateProgression();
                    return Card(
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      color: Colors.blue[800],
                      child: ListTile(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProjectDetail(
                                selectedProject: _projects[index],
                              ),
                            ),
                          );
                        },
                        dense: true,
                        visualDensity: const VisualDensity(vertical: 3),
                        tileColor: const Color.fromRGBO(22, 27, 34, 1),
                        leading: const Icon(Icons.assignment),
                        title: Text(
                          _projects[index].title,
                          style: Theme.of(context).textTheme.displaySmall,
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Progression:'),
                            LinearProgressIndicator(
                              value: progress / 100,
                              backgroundColor: Colors.grey,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Color.lerp(
                                  Colors.red,
                                  Colors.green,
                                  progress / 100,
                                )!,
                              ),
                            ),
                          ],
                        ),
                        trailing: isAdmin()
                            ? IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () {
                                  _confirmDeleteProject(
                                    context,
                                    _projects[index].projectId,
                                  );
                                },
                              )
                            : const Icon(Icons.forward),
                      ),
                    );
                  },
                ),
    );
  }

  bool isAdmin() {
    var currentUser = Auth().currentUser;
    return currentUser?.email?.contains("admin") ?? false;
  }

  Future<void> _confirmDeleteProject(
      BuildContext context, String projectId) async {
    bool confirmDelete = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm Deletion"),
          content: Text("Are you sure you want to delete this project?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pop(false); // User does not want to delete
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // User confirms deletion
              },
              child: Text("Delete"),
            ),
          ],
        );
      },
    );

    if (confirmDelete ?? false) {
      // User confirmed deletion, proceed with the deleteProject function
      deleteProject(context, projectId);
    }
  }

  Future<void> deleteProject(BuildContext context, String projectId) async {
    CollectionReference projects =
        FirebaseFirestore.instance.collection('projects');

    try {
      await projects.doc(projectId).delete();
      print("Project deleted successfully!");
    } catch (error) {
      print("Failed to delete project: $error");
    }
  }
}
