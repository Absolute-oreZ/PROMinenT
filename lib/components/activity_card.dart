import 'package:flutter/material.dart';
import 'package:prominent/models/activity.dart';

class ActivityCard extends StatelessWidget {
  final Activity act;

  const ActivityCard({Key? key, required this.act}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Define icons for each status
    Map<String, IconData> statusIcons = {
      'New': Icons.new_label,
      'On Hold': Icons.pause_circle_filled,
      'In Progress': Icons.timer,
      'Completed': Icons.check_circle,
    };

    // Get the corresponding icon for the status
    IconData? statusIcon = statusIcons[act.status];

    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.deepPurple.shade100,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              act.taskTitle,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Description:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 42, 0, 8),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              act.taskDesc,
              style: const TextStyle(
                  fontSize: 14, color: Colors.teal), // Changed color to teal
            ),
            const SizedBox(height: 12),
            Text(
              'Start Date:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 42, 0, 8),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              act.start,
              style: const TextStyle(
                  fontSize: 14, color: Colors.teal), // Changed color to teal
            ),
            const SizedBox(height: 12),
            Text(
              'End Date:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 42, 0, 8),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              act.end,
              style: const TextStyle(
                  fontSize: 14, color: Colors.teal), // Changed color to teal
            ),
            const SizedBox(height: 12),
            Text(
              'Status:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 42, 0, 8),
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(
                  statusIcon ?? Icons.help_outline,
                  color: Colors.teal, // Changed color to teal
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  act.status,
                  style: const TextStyle(
                      fontSize: 14,
                      color: Colors.teal), // Changed color to teal
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
