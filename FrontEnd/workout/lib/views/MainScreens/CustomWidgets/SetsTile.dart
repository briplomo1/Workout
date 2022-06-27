import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:workout/models/models.dart';

import '../../../constants.dart';
import 'DropdownExercises.dart';

class Item extends StatefulWidget {
  final Function onDelete;
  final state = _ItemState();
  // Need to add functionality to take from prevoious values of set
  WorkoutSet? set;
  Item({
    Key? key,
    this.set,
    required this.onDelete,
  }) : super(key: key);

  @override
  State<Item> createState() => _ItemState();
  bool isValid() => state.validateForm();
}

class _ItemState extends State<Item> {
  GlobalKey<FormState> globalFormKey = new GlobalKey<FormState>();
  WorkoutSet workoutSet = new WorkoutSet();

  /////////////////////////
  String? _exercise;
  bool expanded = true;

  final _setsController = TextEditingController(text: '1');
  final _weightController = TextEditingController(text: '0');
  final _repsController = TextEditingController(text: '1');

  @override
  void dispose() {
    _setsController.dispose();
    _weightController.dispose();
    _repsController.dispose();
    super.dispose();
  }

  bool validateForm() {
    var valid = globalFormKey.currentState!.validate();
    if (valid) globalFormKey.currentState!.save();
    return valid;
  }

  Widget _getTilesList() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Container(
        decoration: getFormBoxDecor(context),
        child: ExpansionTile(
          backgroundColor: Colors.transparent,
          collapsedBackgroundColor: Colors.transparent,
          collapsedIconColor: Color.fromARGB(255, 57, 248, 255),
          iconColor: Color.fromARGB(255, 57, 248, 255),
          initiallyExpanded: true,
          onExpansionChanged: (bool exp) {
            setState(() {
              expanded = exp;
            });
          },
          title: expanded == true
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
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Container(
                //decoration: getFormBoxDecor(),
                child: Form(
                  key: globalFormKey,
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
                                hintText: 'Exercise',
                                value: _exercise,
                                onSaved: (newValue) {
                                  workoutSet.exercise = _exercise ?? '';
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
                                workoutSet.sets = int.parse(value!);
                              },
                              validator: ((value) => (value != null &&
                                      value.length >= 1 &&
                                      int.parse(value) < 20)
                                  ? null
                                  : '1-20 sets allowed'),
                              onChanged: (value) {
                                _exercise = value;
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
                                      color: Colors.grey[700], fontSize: 15.0),
                                ),
                              ),
                            ),
                            Expanded(
                                child: TextFormField(
                              onSaved: (newValue) {
                                workoutSet.weight = double.parse(newValue!);
                              },
                              validator: (value) {
                                value != null && value.length >= 1
                                    ? null
                                    : 'Input a weight';
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
                                      color: Colors.grey[700], fontSize: 15.0),
                                ),
                              ),
                            ),
                            Expanded(
                                child: TextFormField(
                              onSaved: (newValue) =>
                                  workoutSet.reps = int.parse(newValue!),
                              validator: ((value) => (int.parse(value!) >= 1)
                                  ? null
                                  : 'Must contain at t least 1 rep'),
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return _getTilesList();
  }
}
