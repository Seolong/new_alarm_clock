import 'package:get/get.dart';
import 'package:new_alarm_clock/utils/enum.dart';

class RepeatModeController extends GetxController{
  RepeatMode _repeatMode = RepeatMode.off;


  @override
  void onInit() {
    //edit일 때..

    super.onInit();
  }

  @override
  void onClose() {
    //if(back button -> 저장 안함? -> 예)
    //_repeatMode = RepeatMode.default;
  }

  RepeatMode getRepeatMode(){
   return _repeatMode;
  }

  void setRepeatModeOff(){
    _repeatMode = RepeatMode.off;
  }

  void setRepeatMode(int mainIndex, int subIndex){
    if(mainIndex == 0){
      _repeatMode = RepeatMode.single;
    }
    else if(mainIndex == 1){
      switch(subIndex){
        case 0:
          _repeatMode = RepeatMode.day;
          break;
        case 1:
          _repeatMode = RepeatMode.week;
          break;
        case 2:
          _repeatMode = RepeatMode.month;
          break;
        case 3:
          _repeatMode = RepeatMode.year;
          break;
        default:
          print('error in switch in setRepeatMode in RepeatModeController');
      }
    }
    else{
      print('error in setRepeatMode in RepeatModeController');
    }
  }
}