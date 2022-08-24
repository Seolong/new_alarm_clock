import 'package:flutter/material.dart';
import 'auto_size_text.dart';

class CustomRadioListTile<T> extends StatelessWidget {
  final T radioValue;
  final T radioGroupValue;
  final ValueChanged<T?>? onPressed;
  final String title;
  final Color activeColor;
  final Color textColor;
  final double listHeight;
  final double titleFontSize;

  const CustomRadioListTile(
      {required this.radioValue,
      required this.radioGroupValue,
      required this.onPressed,
      required this.title,
      required this.activeColor,
      required this.textColor,
      this.listHeight = 50,
        this.titleFontSize = 25
      });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: listHeight,
      child: Row(
        children: [
          Radio<T>(
            value: radioValue,
            groupValue: radioGroupValue, //초기값
            onChanged: onPressed,
            fillColor: MaterialStateColor.resolveWith((states) {
              if (!states.contains(MaterialState.selected)) {
                return Colors.grey;
              } else {
                return activeColor;
              }
            }),
          ),
          Expanded(
            child: MaterialButton(
              minWidth: 0,
              padding: EdgeInsets.zero,
              onPressed: () {
                onPressed!(radioValue);
              },
              child: Align(
                alignment: Alignment.centerLeft,
                child: SizedBox(
                  height: titleFontSize,
                  child: AutoSizeText(
                    title,
                    color: textColor,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
