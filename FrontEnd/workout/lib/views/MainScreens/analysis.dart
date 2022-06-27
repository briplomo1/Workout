import 'package:flutter/material.dart';
import 'package:workout/views/MainScreens/CustomWidgets/AddExerciseButton.dart';

import '../../constants.dart';
import '../../models/models.dart';
import 'CustomWidgets/DropdownExercises.dart';
import 'CustomWidgets/SetsTile.dart';

class AnalysisScreen extends StatefulWidget {
  @override
  _AnalysisScreenState createState() => _AnalysisScreenState();
}

class _AnalysisScreenState extends State<AnalysisScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: CreateWorkoutForm(),
    );
  }
}

class CreateWorkoutForm extends StatefulWidget {
  const CreateWorkoutForm({Key? key}) : super(key: key);

  @override
  State<CreateWorkoutForm> createState() => _CreateWorkoutFormState();
}

class _CreateWorkoutFormState extends State<CreateWorkoutForm> {
  List<Widget> _setsList = [];
  //This will be used when editing
  List<WorkoutSet> setsList = [];
  Workout workout = new Workout();

  Widget? addExerciseBtn;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> globalFormKey = new GlobalKey<FormState>();

    for (int index = 0; index < setsList.length; index++) {
      _setsList.add(Item(
        key: globalFormKey,
        onDelete: () => onDelete(index),
        set: setsList[index],
      ));
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 30, 15, 8),
      child: Container(
        child: Form(
            key: globalFormKey,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Container(
                    decoration: getFormBoxDecor(context),
                    padding: EdgeInsets.fromLTRB(10, 8, 10, 8),
                    child: TextFormField(
                      onSaved: (newValue) {
                        workout.name = newValue;
                      },
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        letterSpacing: 2.0,
                      ),
                      decoration: getFieldDecoration('Workout Name', context),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                      padding: EdgeInsets.symmetric(vertical: 0),
                      itemCount: setsList.length + 1,
                      itemBuilder: (BuildContext context, int index) {
                        if (index < setsList.length) {
                          return _setsList[index];
                        }
                        return Container(
                            padding: EdgeInsets.symmetric(vertical: 40),
                            color: Colors.transparent,
                            child: Center(
                              child: Ink(
                                decoration: ShapeDecoration(
                                  shadows: [
                                    BoxShadow(
                                      color: Colors.black,
                                      offset: Offset(5, 7),
                                      blurRadius: 6.0,
                                    ),
                                    BoxShadow(
                                      color: Colors.grey[500]!,
                                      offset: Offset(0, -5.0),
                                      blurRadius: 8.0,
                                    ),
                                  ],
                                  shape: CircleBorder(),
                                  color: Color.fromARGB(255, 54, 54, 54),
                                ),
                                child: IconButton(
                                  onPressed: () {
                                    addSet();
                                  },
                                  iconSize: 50.0,
                                  icon: Icon(
                                    Icons.add,
                                    color:
                                        const Color.fromARGB(255, 57, 248, 255),
                                  ),
                                  tooltip: 'Add a new exercise',
                                ),
                              ),
                            ));
                      }),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      onSavedMainForm();
                    },
                    child: Container(
                      height: 60.0,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }

  void addSet() {
    setState(() {
      setsList.add(WorkoutSet());
    });
  }

  void onDelete(int index) {
    setState(() {
      _setsList.removeAt(index);
    });
  }

  void onSavedMainForm() {
    for (int i = 0; i < setsList.length; i++) {
      Item item = _setsList[i] as Item;
      item.isValid();
      setsList[i] = item.state.workoutSet;
    }
    //Validate main form and add sets to Workout class
  }
}
