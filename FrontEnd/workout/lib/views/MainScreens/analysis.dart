import 'package:flutter/material.dart';
import 'package:workout/services/api.dart';
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
  final ex = new Workout(name: "hello", sets: []);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: CreateWorkoutForm(),
    );
  }
}

class CreateWorkoutForm extends StatefulWidget {
  Workout? workout;

  CreateWorkoutForm({this.workout});

  @override
  State<CreateWorkoutForm> createState() => _CreateWorkoutFormState();
}

class _CreateWorkoutFormState extends State<CreateWorkoutForm> {
  //Api instance to create or update workout
  APIService api = new APIService();
  //Id parameter to be used to make put request if a existing workout is given
  //If remains null will make POST call if ID URL given will make PUT call
  String? workoutURI;
  //List of class Item plus addSetButton to populate list view
  List<Item> _ItemsList = [];
  //List of global keys used to manage state of multiple set forms
  List<GlobalKey<ItemState>> _keyList = [];
  //This list will be populated by existing sets when editing existing workout
  //otherwise will be empty
  List<WorkoutSet> _setsList = [];
  //Map of tiles' expansion states
  List<bool> _expansionStates = [];
  //Controller for workout name
  late var _workoutNameController;

  GlobalKey<FormState> globalFormKey = new GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    //if there is an existing workout we are editing: populates lists of sets
    //with exisitng sets in workout otherwise returns empty list
    widget.workout =
        widget.workout == null ? new Workout(sets: _setsList) : widget.workout!;
    widget.workout!.sets =
        widget.workout != null ? widget.workout!.sets : <WorkoutSet>[];
    for (int i = 0; i < _setsList.length; i++) {
      _expansionStates.add(true);
      _keyList.add(new GlobalKey<ItemState>());
      print(_keyList.length);
      // _ItemsList.add(Item(
      //   itemIndex: i,
      //   onDelete: onDelete,
      //   onExpanded: onExpanded,
      //   key: _keyList[i],
      //   workoutSet: _setsList[i],
      //   expanded: _expansionStates[i],
      // ));
    }

    _workoutNameController = TextEditingController(
        text: widget.workout!.name != null ? widget.workout!.name : '');
  }

  @override
  Widget build(BuildContext context) {
    print("Form built>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
    _ItemsList.clear();
    for (int i = 0; i < _setsList.length; i++) {
      print(_expansionStates[i]);
      _ItemsList.add(Item(
          itemIndex: i,
          onDelete: onDelete,
          onExpanded: onExpanded,
          expanded: _expansionStates[i],
          key: _keyList[i]));
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
                      validator: (val) {
                        if (!val!.isNotEmpty) {
                          return "Sets cannot be empty!";
                        }
                        return null;
                      },
                      onSaved: (value) {
                        print('name: ' + value!);
                        widget.workout!.name = value;
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
                      itemCount: _ItemsList.length + 1,
                      itemBuilder: (BuildContext context, int index) {
                        if (index < _ItemsList.length) {
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
                      onSaveWorkout();
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
      _keyList.add(GlobalKey<ItemState>());
      _setsList.add(WorkoutSet());
      _expansionStates.add(true);
      print(_setsList.length);
    });
  }

  void onDelete(int index) {
    setState(() {
      _ItemsList.removeAt(index);
      _setsList.removeAt(index);
    });
  }

  void onExpanded(int itemInd) {
    _expansionStates[itemInd] = !_expansionStates[itemInd];
    _keyList[itemInd].currentState!.setState(() {});

    print('Tile ${itemInd} is expanded: ${_expansionStates[itemInd]}');
  }

  //Validate main form workout.name and add sets to Workout class
  //if uri is provided from workout instance then it is an existing form and will
  //update existing Workout using uri otherwise will crete new Workout
  bool validateMainForm() {
    final form = globalFormKey.currentState;
    if (form != null && form.validate()) {
      form.save();
      return true;
    }
    print("Main form was invalid");
    return false;
  }

//Validate all subforms through keylist and save them to setList
  //to be added to Workout() model to be sent through API
  //Fuction will end if any subform is not valid
  bool validateSetForms() {
    bool valid = true;
    for (int i = 0; i < _setsList.length; i++) {
      print(i);

      if (_keyList[i].currentState!.validateForm()) {
        _setsList[i] = _ItemsList[i].workoutSet!;
        print("Item ${i} is valid");
      } else {
        print('Item ${i} is not valid.');

        valid = false;
      }
    }
    print("Returning from valsets");
    return valid;
  }

//Validates subforms then main form
  void onSaveWorkout() async {
    var valid = validateMainForm();
    print(valid);
    if (validateSetForms() && valid) {
      widget.workout!.sets = _setsList;

      if (workoutURI != null) {
        print("Updating workout");
        await api.updateWorkout(workoutURI!, widget.workout!);
      } else {
        print("Creating workout");
        await api.createWorkout(widget.workout!);
      }
    }
    print('not both valid');
  }
}
