import 'package:get/get.dart';

class TimeSpinnerController extends GetxController{
  RxString _alarmDateTime = ''.obs;

  @override
  void onInit() {
    //edit이면 초기값을 저장되어있는 값으로

    super.onInit();
  }

  set alarmDateTime(DateTime dateTime){
    _alarmDateTime = dateTime.toIso8601String().obs;
    update();
  }

  DateTime get alarmDateTime{
    return DateTime.parse(_alarmDateTime.value);
  }
}