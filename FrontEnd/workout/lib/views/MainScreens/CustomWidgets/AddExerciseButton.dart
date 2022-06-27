import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

Container getIconButon(BuildContext context) => Container(
      padding: EdgeInsets.only(top: 50),
      child: Center(
        child: Ink(
          decoration: ShapeDecoration(
            shadows: [
              BoxShadow(
                color: Color.fromARGB(110, 37, 227, 233),
                offset: Offset(0, 7.0),
                blurRadius: 7.0,
              ),
            ],
            shape: CircleBorder(),
            color: Colors.grey[700],
          ),
          child: IconButton(
            onPressed: () {},
            iconSize: 50.0,
            icon: Icon(
              Icons.add,
              color: Theme.of(context).primaryColor,
            ),
            tooltip: 'Add a new exercise',
          ),
        ),
      ),
    );
