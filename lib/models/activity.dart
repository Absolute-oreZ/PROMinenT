class Activity {
   Activity(
      {required this.taskTitle,
      required this.taskDesc,
      required this.start,
      required this.end,
      required this.status
    });

  final String taskTitle;
  final String taskDesc;
  final String start;
  final String end;
  var status =  'new';
}