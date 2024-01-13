import 'package:prominent/models/activity.dart';

class Project {
  Project({
    required this.projectId,
    required this.title,
    required this.description,
  });

  final String projectId;
  final String title;
  final String description;
  List<Activity> activities = [];
  late int progression;

  int calculateProgression() {
    if (activities.isNotEmpty) {
      int counter = 0; // Initialize counter to 0
      for (var act in activities) {
        if (act.status == "Completed") {
          counter++;
        }
      }
      return progression = ((counter / activities.length) * 100).round();
    } else {
      return progression = 0;
    }
  }
}
