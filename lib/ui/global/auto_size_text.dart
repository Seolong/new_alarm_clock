import 'package:flutter/material.dart';

class AutoSizeText extends StatelessWidget {
  String text;
  bool bold;

  AutoSizeText(this.text, {this.bold = false});

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: ConstrainedBox(
        constraints: BoxConstraints(minWidth: 1, minHeight: 1),
        child: Text(
          text,
          style: TextStyle(
              fontSize: 1000,
            fontWeight: bold ? FontWeight.bold: FontWeight.normal
          ),
        ),
      ),
    );
  }
}
