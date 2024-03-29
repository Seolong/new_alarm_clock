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
  final double spaceBetweenRadioAndTitle;

  const CustomRadioListTile(
      {Key? key,
      required this.value,
      required this.groupValue,
      required this.onChanged,
      required this.title,
      required this.activeColor,
      this.listHeight = 50,
      this.titleFontSize = 25,
      this.titleTextStyle = const TextStyle(fontSize: 16),
      this.spaceBetweenRadioAndTitle = 5})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      minWidth: 0,
      height: listHeight,
      padding: EdgeInsets.zero,
      onPressed: () {
        onChanged!(value);
      },
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
          SizedBox(
            width: spaceBetweenRadioAndTitle,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(title, style: titleTextStyle),
          ),
        ],
      ),
    );
  }
}
