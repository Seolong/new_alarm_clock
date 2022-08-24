import 'package:flutter/material.dart';
import '../../utils/values/size_value.dart';

class CustomSwitchListTile extends StatelessWidget {
  final EdgeInsetsGeometry horizontalPadding;
  final Widget title;
  final Widget switchWidget;
  final bool value;
  final ValueChanged<bool> onChanged;

  const CustomSwitchListTile({
    this.horizontalPadding = const EdgeInsets.symmetric(
        horizontal: 10),
    required this.title,
    required this.switchWidget,
    required this.value,
    required this.onChanged
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      minWidth: 0,
      padding: EdgeInsets.zero,
      onPressed: (){
        value == false
            ? onChanged(true)
            : onChanged(false);
      },
      child: Padding(
        padding: horizontalPadding,
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                alignment: Alignment.bottomLeft,
                height: SizeValue.detailPowerTextHeight,
                child: title,
              ),
              switchWidget
            ]),
      ),
    );
  }
}
