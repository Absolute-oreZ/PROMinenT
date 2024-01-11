import 'package:prominent/models/activity.dart';

class Project {
  Project({
    required this.title,
    required this.description,
  });

  final String title;
  final String description;
  List<Activity> activities = [];
  late int progression;

  int calculateProgression() {
    if (activities.isNotEmpty) {
      int counter = 1;
      for (var act in activities) {
        if (act.status != "Completed") {
          break;
        }

        counter++;
      }
      return (counter / activities.length).round();
    } else {
      return 0;
    }
  }
}
