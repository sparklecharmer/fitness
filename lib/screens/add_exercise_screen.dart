import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/exercise.dart';
import '../utilities/api_calls.dart';
import '../utilities/firebase_calls.dart';

class AddExerciseScreen extends StatefulWidget {
  AddExerciseScreen({Key? key, required this.addTaskCallback}) : super(key: key);
  final Function addTaskCallback;

  @override
  State<AddExerciseScreen> createState() => _AddExerciseScreenState();
}

class _AddExerciseScreenState extends State<AddExerciseScreen> {
  TextEditingController activityController = TextEditingController();
  TextEditingController durationController = TextEditingController();
  TextEditingController userWeightController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: StreamBuilder<QuerySnapshot>(
        stream: fitnessUsersCollection
            .where('userid', isEqualTo: auth.currentUser?.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.docs.isNotEmpty) {
              QueryDocumentSnapshot doc = snapshot.data!.docs[0];
              userWeightController.text = doc.get('weight').toString();
            }
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Add New Task',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.cyan, fontSize: 24.0),
              ),
              TextField(
                autofocus: true,
                textAlign: TextAlign.center,
                decoration: const InputDecoration(labelText: 'Activity'),
                controller: activityController,
              ),
              TextField(
                textAlign: TextAlign.center,
                decoration: const InputDecoration(labelText: 'Duration'),
                controller: durationController,
                keyboardType: TextInputType.number,
              ),
              ElevatedButton(
                onPressed: () {
                  widget.addTaskCallback(
                    activityController.text,
                    int.parse(durationController.text),
                    int.parse(userWeightController.text),
                  );
                  Navigator.pop(context);
                },
                child: const Text('Add'),
              ),
            ],
          );
        },
      ),
    );
  }
}
