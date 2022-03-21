import 'package:get/get.dart';
import 'package:new_alarm_clock/utils/enum.dart';

class RepeatModeController extends GetxController{
  RepeatMode repeatMode = RepeatMode.off;
  RepeatMode previousRepeatMode = RepeatMode.off;

  RepeatMode getRepeatMode(){
   return repeatMode;
  }

  void setRepeatModeOff(){
    repeatMode = RepeatMode.off;
  }

  void setRepeatModeWeek(){
    repeatMode = RepeatMode.week;
  }

  void setRepeatMode(int mainIndex, int subIndex){
    if(mainIndex == 0){
      repeatMode = RepeatMode.single;
    }
    else if(mainIndex == 1){
      switch(subIndex){
        case 0:
          repeatMode = RepeatMode.day;
          break;
        case 1:
          repeatMode = RepeatMode.week;
          break;
        case 2:
          repeatMode = RepeatMode.month;
          break;
        case 3:
          repeatMode = RepeatMode.year;
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