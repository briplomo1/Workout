import 'package:flutter/material.dart';
import 'package:workout/services/api.dart';
import '../../constants.dart';
import '../../models/models.dart';
import 'CustomWidgets/SetsTile.dart';
import 'CustomWidgets/WorkoutForm.dart';

///Must get workouts on this page
///Must refresh workouts on creation of workout

class AnalysisScreen extends StatefulWidget {
  @override
  _AnalysisScreenState createState() => _AnalysisScreenState();
}

///////////////////////////
class _AnalysisScreenState extends State<AnalysisScreen> {
  APIService api = new APIService();
  final ex = new Workout(name: "hello", sets: []);
  List<Exercise>? exercises;

  void getExercises() async {
    exercises = await api.getExercises();
    exercises?.forEach((element) {
      print(element.name);
    });
  }

  @override
  Widget build(BuildContext context) {
    getExercises();
    return Container(
      child: CreateWorkoutForm(),
    );
  }
}
