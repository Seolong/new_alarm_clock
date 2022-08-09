import 'package:flutter/material.dart';
import 'auto_size_text.dart';

class CustomRadioListTile<T> extends StatelessWidget {
  final dynamic radioValue;
  final dynamic radioGroupValue;
  final ValueChanged<T?>? onPressed;
  final String title;
  final Color activeColor;
  final Color textColor;

  const CustomRadioListTile({
    required this.radioValue,
    required this.radioGroupValue,
    required this.onPressed,
    required this.title,
    required this.activeColor,
    required this.textColor
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: Row(
        children: [
          Radio<T>(
            value: radioValue,
            groupValue: radioGroupValue, //초기값
            onChanged: onPressed,
            activeColor: activeColor,
          ),
          Expanded(
            child: MaterialButton(
              minWidth: 0,
              padding: EdgeInsets.zero,
              onPressed: (){
                onPressed!(radioValue);
              },
              child: Align(
                alignment: Alignment.centerLeft,
                child: SizedBox(
                  height: 25,
                  child: AutoSizeText(title,
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
