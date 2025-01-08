import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/exercise.dart';
import '../models/fitness_user.dart';

late FitnessUser fitnessUser;
bool newUser = false;

FirebaseAuth auth = FirebaseAuth.instance;
CollectionReference fitnessUsersCollection =
    FirebaseFirestore.instance.collection('fitnessUsers');
CollectionReference exercisesCollection =
    FirebaseFirestore.instance.collection('exercises');

class FirebaseCalls {
  Future<FitnessUser> getFitnessUser(String uid) async {
    QuerySnapshot querySnap =
        await fitnessUsersCollection.where('userid', isEqualTo: uid).get();

    if (querySnap.docs.isNotEmpty) {
      QueryDocumentSnapshot doc = querySnap.docs[0];
      fitnessUser = FitnessUser(
        weight: doc.get('weight'),
        height: doc.get('height'),
        gender: doc.get('gender'),
        age: doc.get('age'),
        exercise: doc.get('exercise')
      );
    } else {
      newUser = true;
      fitnessUser = FitnessUser(
        weight: 0,
        height: 0,
        age: 0,
        gender: 'male',
        exercise: 'none'
      );
    }
    return fitnessUser;
  }

  Future<void> updateFitnessUser(FitnessUser fitnessUser) async {
    //check if there is an existing record of user
    QuerySnapshot querySnap = await fitnessUsersCollection
        .where('userid', isEqualTo: auth.currentUser?.uid)
        .get();

    if (querySnap.docs.isNotEmpty) {
      //Existing user
      QueryDocumentSnapshot doc = querySnap.docs[0];
      await doc.reference.update({
        'weight': fitnessUser.weight,
        'height': fitnessUser.height,
        'gender': fitnessUser.gender,
        'age': fitnessUser.age,
        'exercise': fitnessUser.exercise,
      });
    } else {
      //New user
      await fitnessUsersCollection.add({
        'weight': fitnessUser.weight,
        'height': fitnessUser.height,
        'gender': fitnessUser.gender,
        'age': fitnessUser.age,
        'exercise': fitnessUser.exercise,
        'userid': auth.currentUser?.uid
      });
    }
  }

  Future<void> updateExercise(Exercise exercise) async {
    QuerySnapshot querySnap = await exercisesCollection
        .where('userid', isEqualTo: auth.currentUser?.uid)
        .get();

    if (querySnap.docs.isNotEmpty) {
      //Existing user
      QueryDocumentSnapshot doc = querySnap.docs[0];
      await doc.reference.update({
        'activity': exercise.activity,
        'duration': exercise.duration,
        'weight': fitnessUser.weight,
      });
    } else {
      //New user
      await exercisesCollection.add({
        'activity': 'skiing', //default values
        'duration': 60, //default values
        'weight': 160, //default values
        'userid': auth.currentUser?.uid
      });
    }
    //TODO Add newExercise to exercises collection
  }
}
