class Activity {
  Activity({
    required this.docID,
    required this.taskTitle,
    required this.taskDesc,
    required this.start,
    required this.end,
    this.status = 'new',
  });

  late String docID;
  final String taskTitle;
  final String taskDesc;
  final String start;
  final String end;
  final String status;
}
