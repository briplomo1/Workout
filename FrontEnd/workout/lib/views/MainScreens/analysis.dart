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

///////////////////////////
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
  Workout? workout;

  CreateWorkoutForm({Key? key, this.workout}) : super(key: key);

  @override
  State<CreateWorkoutForm> createState() => _CreateWorkoutFormState();
}

class _CreateWorkoutFormState extends State<CreateWorkoutForm> {
  //Id parameter to be used to make put request if a existing workout is given
  //If remains null will make POST call if ID given will make PUT call
  int? workoutID;
  //List of class Item plus addSetButton to populate list view
  List<Widget> _ItemsList = [];
  //This list will be populated by existing sets when editing existing workout
  //otherwise will be empty
  late List<WorkoutSet> _setsList;
  //Controller for workout name
  late TextEditingController _workoutNameController;
  GlobalKey<FormState> globalFormKey = new GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    //workoutID = widget.workout != null ? widget.
    _workoutNameController = TextEditingController(
        text: widget.workout != null ? widget.workout!.name : '');
    _setsList = widget.workout != null ? widget.workout!.sets : <WorkoutSet>[];
  }

  @override
  Widget build(BuildContext context) {
    for (int index = 0; index < _setsList.length; index++) {
      // For every workoutSet creates a Item widget
      _ItemsList.add(Item(
        key: globalFormKey,
        onDelete: () => onDelete(index),
        workoutSet: _setsList[index],
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
                      controller: _workoutNameController,
                      validator: (val) => val != null || val != ''
                          ? null
                          : 'Enter a name for your workout',
                      onSaved: (newValue) {
                        widget.workout!.name = newValue;
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
                      itemCount: _setsList.length + 1,
                      itemBuilder: (BuildContext context, int index) {
                        if (index < _setsList.length) {
                          return _ItemsList[index];
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
      _setsList.add(WorkoutSet());
    });
  }

  void onDelete(int index) {
    setState(() {
      _ItemsList.removeAt(index);
    });
  }

  bool validateAndSaveForm() {
    final form = globalFormKey.currentState!;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void onSavedMainForm() {
    for (int i = 0; i < _setsList.length; i++) {
      //Validate all subforms and save them to setList to be added to workoutModel
      Item item = _ItemsList[i] as Item;
      if (item.isValid()) {
        _setsList[i] = item.workoutSet!;
      } else {
        return;
      }
    }
    //Check validate main form and add sets to Workout class
    if (validateAndSaveForm()) {
      widget.workout!.sets = _setsList;
      //
    }
  }
}
