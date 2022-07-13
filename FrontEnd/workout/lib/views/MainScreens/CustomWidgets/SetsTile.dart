import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:workout/models/models.dart';

import '../../../constants.dart';
import 'DropdownExercises.dart';

class Item extends StatefulWidget {
  final Function onDelete;
  bool isExpanded;
  WorkoutSet? existing;
  WorkoutSet workoutSet = new WorkoutSet();
  //bool expanded;
  final int itemIndex;

  Item({
    required this.isExpanded,
    required this.itemIndex,
    required this.onDelete,
    required Key key,
    existing,
  }) : super(key: key);

  @override
  State<Item> createState() => ItemState();
  //bool isValid() => state.validateForm();
}

class ItemState extends State<Item> {
  /////////////////////////are parametea
  String? _exercise;

  final GlobalKey<FormState> form = new GlobalKey();

  bool validateForm() {
    var valid = form.currentState!.validate();
    print('Validate form');
    if (form.currentState != null && valid) {
      form.currentState!.save();
      return true;
    }

    return false;
  }

  late var _setsController;
  late var _weightController;
  late var _repsController;

  @override
  void initState() {
    super.initState();

    //initialize tilekey to given key

    //////////////////////////////////////
    /////if workout set is supplied from existing set:
    //Current set will take on the given set's values.
    //Field controllers will be set to given values or will default.
    widget.workoutSet = widget.existing ?? new WorkoutSet();
    _exercise = widget.existing != null ? widget.workoutSet.exercise : null;
    _setsController = TextEditingController(
        text: widget.existing != null ? widget.existing!.sets.toString() : '');
    _weightController = TextEditingController(
        text:
            widget.existing != null ? widget.existing!.weight.toString() : '');
    _repsController = TextEditingController(
        text: widget.existing != null ? widget.existing!.reps.toString() : '');
  }

  @override
  void dispose() {
    _setsController.dispose();
    _weightController.dispose();
    _repsController.dispose();
    super.dispose();
  }

  void expandTile() {
    setState(() {
      widget.isExpanded = !widget.isExpanded;
    });
  }

////////////////////////////////////////////////////////

  Widget _getTilesList() {
    print('Rebuilding set');
    print(widget.isExpanded);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Container(
        decoration: getFormBoxDecor(context),
        child: Form(
          key: form,
          child: ExpansionPanelList(
            expansionCallback: (panelIndex, isExpanded) => expandTile(),
            children: [
              ExpansionPanel(
                backgroundColor: Colors.transparent,
                isExpanded: widget.isExpanded,
                headerBuilder: (BuildContext context, bool isExpanded) =>
                    widget.isExpanded == true
                        ? Container(
                            height: 1.0,
                          )
                        : Container(
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                    flex: 2,
                                    child: Text(
                                      _exercise == null
                                          ? '?'
                                          : _exercise!.length > 10
                                              ? _exercise!.replaceRange(
                                                  10, _exercise!.length, '...')
                                              : _exercise!,
                                      style: TextStyle(
                                        color: Colors.grey[500],
                                        fontSize: 16.0,
                                      ),
                                    )),
                                SizedBox(
                                  width: 20,
                                ),
                                Expanded(
                                    child: Text(
                                  _setsController.text.toString(),
                                  textAlign: TextAlign.center,
                                  style: getFormTextStyle(),
                                )),
                                SizedBox(
                                  width: 20,
                                  child: Text(
                                    'X',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.grey[700]),
                                  ),
                                ),
                                Expanded(
                                    child: Text(
                                  _weightController.text,
                                  textAlign: TextAlign.center,
                                  style: getFormTextStyle(),
                                )),
                                SizedBox(
                                  width: 20,
                                  child: Text(
                                    'X',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.grey[700]),
                                  ),
                                ),
                                Expanded(
                                    child: Text(
                                  _repsController.text,
                                  textAlign: TextAlign.center,
                                  style: getFormTextStyle(),
                                )),
                              ],
                            ),
                          ),
                body: Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Container(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(15, 8, 15, 8),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: DropDownFormField(
                                  border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10.0)),
                                    borderSide: BorderSide(
                                        color: Colors.transparent, width: 2.0),
                                  ),

                                  //////////////////////////////
                                  hintText: 'Exercise',
                                  value: _exercise,
                                  onSaved: (newValue) {
                                    widget.workoutSet.exercise =
                                        _exercise ?? '';
                                  },
                                  onChanged: (newValue) {
                                    setState(() {
                                      _exercise = newValue;
                                    });
                                  },
                                  dataSource: [
                                    'Bench Press',
                                    'Squat',
                                    'Dumbell Flies',
                                    'Deadlift',
                                    'RDL',
                                    'Dumbell Bicep Curl'
                                  ],
                                  textField: 'display',
                                  valueField: 'value',
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(15, 20, 15, 15),
                          child: Row(
                            children: [
                              Expanded(
                                  child: TextFormField(
                                onSaved: (value) {
                                  widget.workoutSet.sets = int.parse(value!);
                                },
                                validator: (value) {
                                  if (!value!.isNotEmpty) {
                                    return "Sets cannot be empty!";
                                  }
                                  return null;
                                },
                                onChanged: (value) {
                                  setState(() {});
                                },
                                controller: _setsController,
                                keyboardType: TextInputType.number,
                                style: getFormTextStyle(),
                                decoration:
                                    getNumberFieldDecoration('Sets', context),
                              )),
                              SizedBox(
                                width: 50,
                                child: Center(
                                  child: Text(
                                    'X',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.grey[700],
                                        fontSize: 15.0),
                                  ),
                                ),
                              ),
                              Expanded(
                                  child: TextFormField(
                                onSaved: (newValue) {
                                  widget.workoutSet.weight =
                                      double.parse(newValue!);
                                },
                                validator: (value) {
                                  ////////////////////////////
                                  if (!value!.isNotEmpty) {
                                    return "Weight cannot be empty!";
                                  }
                                  return null;
                                },
                                onChanged: (value) {
                                  setState(() {});
                                },
                                controller: _weightController,
                                keyboardType: TextInputType.number,
                                style: getFormTextStyle(),
                                decoration:
                                    getNumberFieldDecoration('Weight', context),
                              )),
                              SizedBox(
                                width: 50,
                                child: Center(
                                  child: Text(
                                    'X',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.grey[700],
                                        fontSize: 15.0),
                                  ),
                                ),
                              ),
                              Expanded(
                                  child: TextFormField(
                                onSaved: (newValue) => widget.workoutSet.reps =
                                    int.parse(newValue!),
                                validator: (value) {
                                  ///////////////////////////
                                  if (!value!.isNotEmpty) {
                                    return "Reps cannot be empty!";
                                  }
                                  return null;
                                },
                                onChanged: (value) {
                                  setState(() {});
                                },
                                controller: _repsController,
                                keyboardType: TextInputType.number,
                                style: getFormTextStyle(),
                                decoration:
                                    getNumberFieldDecoration('Reps', context),
                              )),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print('build widget');
    return _getTilesList();
  }
}
