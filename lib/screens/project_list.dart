import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:prominent/firebase/auth.dart';
import 'package:prominent/models/project.dart';
import 'package:prominent/screens/project_details.dart';
import 'package:prominent/screens/register_project.dart';

class ProjecList extends StatefulWidget {
  const ProjecList({Key? key}) : super(key: key);

  @override
  _ProjectListState createState() => _ProjectListState();
}

class _ProjectListState extends State<ProjecList> {
  var _isLoading = true;

  //load items from cloudfire firestore
  /*
  *    Title        : LoadItemsFromFirestore
  *    Author       : Airon Tark,Philippe Fanaro
  *    Date         : 7/1/2024
  *    Code version : 1.0
  *    Availability : https://stackoverflow.com/questions/59529177/how-to-read-data-from-firestore-flutter
  */
  List<Project> _projects = [];
  Future<void> fetchProjectList() async {
    List<Project> loadedProjects = [];
    try {
      var data = await FirebaseFirestore.instance.collection("projects").get();
      for (int i = 0; i < data.docs.length; i++) {
        if (data.docs[i].data()['user'] == Auth().currentUser?.uid) {
          Project project = Project(
            title: data.docs[i].data()['title'],
            description: data.docs[i].data()['description'],
            // projectTimeLine: data.docs[i].data()['projectTimeLine']
          );
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
    return Scaffold(
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _projects.isEmpty
                ? Center(
                    child: Row(
                    children: [
                      const Text('No project added yet.'),
                      ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const RegisterProject(),
                            ));
                          },
                          child: Text(
                            'Add One!',
                            style: Theme.of(context).textTheme.displayLarge,
                          ))
                    ],
                  ))
                : ListView.builder(
                    itemCount: _projects.length,
                    itemBuilder: (context, index) {
                      return Card(
                        elevation: 5, //Step 2 - Enhance spacing..
                        margin: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 5),
                        child: ListTile(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ProjectDetail(
                                      selectedProject: _projects[index])),
                            );
                          },
                          //specify height
                          //source: https://stackoverflow.com/questions/53071451/how-to-specify-listtile-height-in-flutter
                          dense: true,
                          visualDensity:
                              const VisualDensity(vertical: 3), // to expand
                          tileColor: const Color.fromRGBO(22, 27, 34, 1),
                          leading: const Icon(Icons.assignment),
                          title: Text(_projects[index].title,
                              style: Theme.of(context).textTheme.displaySmall),
                          subtitle: Text(
                            "${_projects[index].description}}",
                            style: const TextStyle(color: Colors.white),
                          ),
                          trailing:
                              Text('${_projects[index].calculateProgression()}%'
                                  // DateFormat()
                                  //     .add_yMd()
                                  //     .format(_projects[index].),
                                  // style: const TextStyle(
                                  //     fontWeight: FontWeight.bold,
                                  //     fontSize: 14,
                                  //     color: Colors.red),
                                  ),
                        ),
                      );
                    }));
  }
}
