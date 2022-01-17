import 'package:new_alarm_clock/utils/enum.dart';
import 'package:vibration/vibration.dart';

class VibrationPack{

  VibrationName? convertRadioNameToVibrationName(String name){
    switch(name){
      case 'Long':
        return VibrationName.long;
      case 'Heartbeat':
        return VibrationName.heartBeat;
      default:
        assert(false, 'error in convertRadioNameToVibrationName of VibrationPack');
    }
  }

  String? convertVibrationNameToRadioName(VibrationName vibrationName){
    switch(vibrationName){
      case VibrationName.long:
        return 'Long';
      case VibrationName.heartBeat:
        return 'Heartbeat';
      default:
        assert(false, 'error in convertVibrationNameToRadioName of VibrationPack');
    }
  }

  void vibrateByName(String name){
    VibrationName? vibrationName = convertRadioNameToVibrationName(name);
    switch(vibrationName){
      case VibrationName.long:
        longVibrate();
        break;
      case VibrationName.heartBeat:
        heartbeat();
        break;
      default:
        assert(false, 'error in vibrateByName of VibrationPack');
    }
  }

  void vibrateByVibrationName(VibrationName vibrationName){
    switch(vibrationName){
      case VibrationName.long:
        longVibrate();
        break;
      case VibrationName.heartBeat:
        heartbeat();
        break;
      default:
        assert(false, 'error in vibrateByVibrationName of VibrationPack');
    }
  }

  void longVibrate(){
    //Vibration.cancel(); 안해도 되는듯
    List<int> patternList = [];
    for(int i = 0; i < 30; i++){
      patternList.addAll([0, 1500, 500, 0]);
    }
    Vibration.vibrate(pattern: patternList);
  }

  void heartbeat(){
    List<int> patternList = [];
    for(int i = 0; i < 80; i++){
      patternList.addAll([0, 250, 10, 240, 250, 0]);
    }
    Vibration.vibrate(pattern: patternList);
  }
}