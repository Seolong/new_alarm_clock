import 'package:flutter/material.dart';

class CustomRadioListTile<T> extends StatelessWidget {
  final T value;
  final T groupValue;
  final ValueChanged<T?>? onChanged;
  final String title;
  final Color activeColor;
  final double listHeight;
  final double titleFontSize;
  final TextStyle titleTextStyle;

  const CustomRadioListTile(
      {required this.value,
      required this.groupValue,
      required this.onChanged,
      required this.title,
      required this.activeColor,
      this.listHeight = 50,
      this.titleFontSize = 25,
      this.titleTextStyle = const TextStyle(fontSize: 16)});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: listHeight,
      child: Row(
        children: [
          Radio<T>(
            value: value,
            groupValue: groupValue, //초기값
            onChanged: onChanged,
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
                onChanged!(value);
              },
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(title, style: titleTextStyle),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
