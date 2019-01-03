import 'package:flutter/material.dart';

class TwoOptionsButtonBar extends StatelessWidget {
  final String leftText;
  final String rightText;
  final Function onLeft;
  final Function onRight;

  TwoOptionsButtonBar({
    this.leftText = 'Skip',
    this.rightText = 'Submit',
    this.onLeft,
    this.onRight,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        RaisedButton(
          child: Text(leftText),
          onPressed: onLeft,
        ),
        RaisedButton(
          child: Text(rightText),
          onPressed: onRight,
        ),
      ],
    );
  }
}
