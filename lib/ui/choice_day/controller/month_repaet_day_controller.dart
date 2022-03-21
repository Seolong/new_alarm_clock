import 'package:get/get.dart';

class MonthRepeatDayController extends GetxController{
  //29일은 말일
  Rx<int?> _monthRepeatDay = null.obs;
  RxString monthRepeatDayText = ''.obs;

  set monthRepeatDay(int? value){
    _monthRepeatDay = value.obs;
    if(value != 29){
      monthRepeatDayText = '${_monthRepeatDay}일에'.obs;
    }
    else{
      monthRepeatDayText = '말일에'.obs;
    }
    update();
  }

  int? get monthRepeatDay => _monthRepeatDay.value;

  void initInEdit(int? value){
    _monthRepeatDay = value.obs;
  }
}