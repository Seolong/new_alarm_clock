import 'package:get/get.dart';

class TimeSpinnerController extends GetxController{
  RxString _alarmDateTime = '2000-01-01T00:00:00.000'.obs;

  @override
  void onInit() {
    _alarmDateTime = DateTime.now().toIso8601String().obs;

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