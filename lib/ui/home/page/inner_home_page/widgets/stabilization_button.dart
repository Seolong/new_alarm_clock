import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:new_alarm_clock/routes/app_routes.dart';

class StabilizationButton extends StatelessWidget {
  const StabilizationButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(horizontal: 50),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.yellow, width: 5),
            borderRadius: BorderRadius.circular(5)
      ),
      child: ElevatedButton(
        onPressed: () { Get.toNamed(AppRoutes.stabilizationPage); },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.black),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.warning_rounded, color: Colors.yellow,),
              const SizedBox(width: 8,),
              Text('알람 기능 안정화 시키기', style: TextStyle(
                fontSize: 16,
                color: Colors.white
              ),),
              const SizedBox(width: 8,),
              const Icon(Icons.chevron_right_rounded)
            ],
          ),
        ),
      ),
    );
  }
}
