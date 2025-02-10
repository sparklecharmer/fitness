import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness/utilities/api_calls.dart';
import 'package:flutter/material.dart';

import '../models/exercise.dart';
import '../models/fitness_user.dart';

late FitnessUser fitnessUser;
late Exercise exercise;
final apiCalls = ApiCalls();
bool newUser = false;

FirebaseAuth auth = FirebaseAuth.instance;
CollectionReference fitnessUsersCollection = FirebaseFirestore.instance.collection('fitnessUsers');
CollectionReference exercisesCollection = FirebaseFirestore.instance.collection('exercises');

class FirebaseCalls {

  Future<FitnessUser> getFitnessUser(String uid) async {

    QuerySnapshot querySnap = await fitnessUsersCollection.where('userid', isEqualTo: uid).get();

    if (querySnap.docs.isNotEmpty) {
      QueryDocumentSnapshot doc = querySnap.docs[0];
      fitnessUser = FitnessUser(
        weight: doc.get('weight'),
        height: doc.get('height'),
        gender: doc.get('gender'),
        age: doc.get('age'),
        exercise: doc.get('exercise'),
        neck: doc.get('neck'),
        waist: doc.get('waist'),
        goal: doc.get('goal'),
        deficit: doc.get('deficit'),
        goalWeight: doc.get('goalWeight')
      );
    } else {
      newUser = true;
      fitnessUser = FitnessUser(
        weight: 0,
        height: 0,
        age: 0,
        gender: 'male',
        exercise: 'little',
        neck: 0,
        hip: 0,
        waist: 0,
        goal: "maintenance",
        deficit: 0,
        goalWeight: 0,

      );
    }
    return fitnessUser;
  }


  Future<void> updateFitnessUser(FitnessUser fitnessUser) async {

    QuerySnapshot querySnap = await fitnessUsersCollection.where('userid', isEqualTo: auth.currentUser?.uid).get();

     if (querySnap.docs.isNotEmpty) {
      QueryDocumentSnapshot doc = querySnap.docs[0];
      await doc.reference.update({
        'weight': fitnessUser.weight,
        'height': fitnessUser.height,
        'gender': fitnessUser.gender,
        'age': fitnessUser.age,
        'exercise': fitnessUser.exercise,
        'neck' : fitnessUser.neck,
        'waist': fitnessUser.waist,
        'goal': fitnessUser.goal,
        'deficit': fitnessUser.deficit,
        'goalWeight': fitnessUser.goalWeight,
      });
    } else {
      await fitnessUsersCollection.add({
        'weight': fitnessUser.weight,
        'height': fitnessUser.height,
        'gender': fitnessUser.gender,
        'age': fitnessUser.age,
        'exercise': fitnessUser.exercise,
        'neck' : fitnessUser.neck,
        'waist': fitnessUser.waist,
        'goal': fitnessUser.goal,
        'deficit': fitnessUser.deficit,
        'goalWeight': fitnessUser.goalWeight,
        'userid': auth.currentUser?.uid
      });
    }
  }


  Future<Exercise> getExercise(String uid) async {

    QuerySnapshot querySnap = await exercisesCollection.where('userid', isEqualTo: uid).get();

    if (querySnap.docs.isNotEmpty) {
      QueryDocumentSnapshot doc = querySnap.docs[0];
      exercise = Exercise(
        activity: doc.get('activity'),
        duration: doc.get('duration'),
      );

    } else {
      newUser = true;
      exercise = Exercise(
        activity: 'skiing',
        duration: 60,
      );
    }
    return exercise;
  }


  Future<void> addExercise(Exercise exercise) async {

    QuerySnapshot querySnap = await fitnessUsersCollection.where('userid', isEqualTo: auth.currentUser?.uid).get();
    QueryDocumentSnapshot doc = querySnap.docs[0];

    int weight = doc.get('weight');
    int burnedCalories = await apiCalls.fetchBurnedCalories(exercise.activity, weight, exercise.duration);
      await exercisesCollection.add({
        'userid': auth.currentUser?.uid,
        'activity': exercise.activity,
        'weight': weight,
        'duration': exercise.duration,
        'burnedCalories': burnedCalories,
      });
  }
}
