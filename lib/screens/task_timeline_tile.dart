import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:prominent/components/activity_card.dart';
import 'package:prominent/screens/edit_activity.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:prominent/models/activity.dart';
import 'package:prominent/firebase/auth.dart';

class TaskTimelineTile extends StatelessWidget {
  final bool isFirst;
  final bool isLast;
  final bool isPast;
  final Activity act;

  const TaskTimelineTile({
    super.key,
    required this.isFirst,
    required this.isLast,
    required this.isPast,
    required this.act,
  });

  @override
  Widget build(BuildContext context) {
    var isAdmin = Auth().currentUser?.email?.contains("admin") ?? false;

    return SizedBox(
      child: TimelineTile(
        isFirst: isFirst,
        isLast: isLast,
        beforeLineStyle: LineStyle(
          color: isPast ? Colors.deepPurple : Colors.deepPurple.shade100,
        ),
        indicatorStyle: IndicatorStyle(
          width: 40,
          color: isPast ? Colors.deepPurple : Colors.deepPurple.shade100,
          iconStyle: IconStyle(
            iconData: isPast ? Icons.done : Icons.queue,
            color: Colors.deepPurple.shade100,
          ),
        ),
        endChild: Row(
          children: [
            ActivityCard(act: act),
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => EditActivity(act: act),
                  ),
                );
              },
              child: const Icon(Icons.edit),
            ),
            const SizedBox(width: 8),
            if (isAdmin)
              GestureDetector(
                onTap: () {
                  deleteActivity(context, act.docID);
                },
                child: const Icon(Icons.delete),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> deleteActivity(BuildContext context, String docID) async {
    var currentUser = Auth().currentUser;

    if (currentUser != null) {
      // Check if the current user is an admin
      bool isAdmin = currentUser.email?.contains("admin") ?? false;

      if (isAdmin) {
        // Only allow deletion if the user is an admin
        CollectionReference activity =
            FirebaseFirestore.instance.collection('activities');

        try {
          await activity.doc(docID).delete();
          print("Activity deleted successfully!");
        } catch (error) {
          print("Failed to delete Activity: $error");
        }
      } else {
        // Display a message or handle the case where the user is not an admin
        print("Only admin can delete activities");
      }
    }
  }
}
