library dropdown_formfield;

import 'package:flutter/material.dart';

class DropDownFormField extends FormField<dynamic> {
  final String? titleText;
  final String hintText;
  final bool? required;
  final String? errorText;
  final dynamic value;
  final List? dataSource;
  final String? textField;
  final String? valueField;
  final Function? onChanged;
  final bool? filled;
  final EdgeInsets? contentPadding;
  final InputBorder? border;
  String? itemValue;
  DropDownFormField(
      {FormFieldSetter<dynamic>? onSaved,
      FormFieldValidator<dynamic>? validator,
      AutovalidateMode autovalidate = AutovalidateMode.disabled,
      this.border,
      this.titleText,
      this.hintText = 'Select one option',
      this.required = false,
      this.errorText = 'Please select one option',
      this.value,
      this.dataSource,
      this.textField,
      this.valueField,
      this.onChanged,
      this.filled = true,
      this.contentPadding = const EdgeInsets.fromLTRB(10, 0, 10, 0)})
      : super(
          onSaved: onSaved,
          validator: validator,
          autovalidateMode: autovalidate,
          initialValue: value == '' ? null : value,
          builder: (FormFieldState<dynamic> state) {
            return Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  InputDecorator(
                    decoration: InputDecoration(
                      enabledBorder: border,
                      contentPadding: contentPadding,
                      labelText: titleText,
                      filled: filled,
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<dynamic>(
                        alignment: Alignment.bottomCenter,
                        dropdownColor: Colors.grey[700],
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        isExpanded: true,
                        style: TextStyle(color: Colors.white, fontSize: 20.0),
                        hint: Text(
                          hintText,
                          style: TextStyle(
                              color: Colors.grey[500], fontSize: 18.0),
                        ),
                        value: value,
                        onChanged: (dynamic newValue) {
                          state.didChange(newValue);
                          onChanged!(newValue);
                        },
                        items: dataSource!.map((item) {
                          print(item);
                          return DropdownMenuItem<dynamic>(
                            value: item,
                            child: Text(
                              item,
                              style: TextStyle(color: Colors.white),
                              overflow: TextOverflow.ellipsis,
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
}
