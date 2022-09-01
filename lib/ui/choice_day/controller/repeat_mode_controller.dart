import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:new_alarm_clock/utils/enum.dart';

class RepeatModeController extends GetxController {
  RepeatMode _repeatMode = RepeatMode.off;
  RxInt subIndex = 0.obs;

  RepeatMode previousRepeatMode = RepeatMode.off;

  RepeatMode get repeatMode => _repeatMode;

  set repeatMode(RepeatMode repeatMode) {
    _repeatMode = repeatMode;

    //ChoiceDayPage에 Builder 써서 이거 써야한다.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // executes after build

      //chioceDay의 초기 subTabBarIndex 설정을 위해
      subIndex.value = getSubIndex();

      update();
    });
  }

  int getMainIndex() {
    switch (_repeatMode) {
      case RepeatMode.off:
      case RepeatMode.single:
        return 0;
      case RepeatMode.day:
      case RepeatMode.week:
      case RepeatMode.month:
      case RepeatMode.year:
        return 1;
      default:
        assert(false, 'getMainIndex error in RepeatModeController');
        return -1;
    }
  }

  int getSubIndex() {
    switch (_repeatMode) {
      case RepeatMode.off:
      case RepeatMode.single:
      case RepeatMode.day:
        return 0;
      case RepeatMode.week:
        return 1;
      case RepeatMode.month:
        return 2;
      case RepeatMode.year:
        return 3;
      default:
        if (kDebugMode) {
          print(_repeatMode);
        }
        assert(false, 'getSubIndex error in RepeatModeController');
        return -1;
    }
  }

  RepeatMode getRepeatMode() {
    return repeatMode;
  }

  void setRepeatModeOff() {
    repeatMode = RepeatMode.off;
  }

  void setRepeatModeWeek() {
    repeatMode = RepeatMode.week;
  }

  void setRepeatMode(int mainIndex, int subIndex) {
    if (mainIndex == 0) {
      repeatMode = RepeatMode.single;
    } else if (mainIndex == 1) {
      switch (subIndex) {
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
          if (kDebugMode) {
            print('error in switch in setRepeatMode in RepeatModeController');
          }
      }
    } else {
      if (kDebugMode) {
        print('error in setRepeatMode in RepeatModeController');
      }
    }
  }

  String getRepeatModeText(
    String interval,
    int? monthRepeatDay,
  ) {
    switch (repeatMode) {
      case RepeatMode.off:
      case RepeatMode.single:
        return '';
      case RepeatMode.day:
        return interval == '1' ? '일 반복' : '일마다 반복';
      case RepeatMode.week:
        return interval == '1' ? '주 반복' : '주마다 반복';
      case RepeatMode.month:
        return interval == '1'
            ? '달 $monthRepeatDay일에 반복'
            : '달마다 $monthRepeatDay일에 반복';
      case RepeatMode.year:
        return interval == '1' ? '년 반복' : '년마다 반복';
      default:
        assert(false, 'getRepeatModeText error in AddAlarmPage');
        return '';
    }
  }
}
