import 'package:easy_localization/easy_localization.dart';
import 'package:new_alarm_clock/generated/locale_keys.g.dart';
import 'package:new_alarm_clock/routes/app_routes.dart';
import 'package:get/get.dart' hide Trans;

class AlarmDetailPageFactory{

  void getAlarmDetailPage(String pageName){
    if(LocaleKeys.ringtone.tr() == pageName){
      Get.toNamed(AppRoutes.ringPage);
    }else if(LocaleKeys.vibration.tr() == pageName){
      Get.toNamed(AppRoutes.vibrationPage);
    }else if(LocaleKeys.repeat.tr() == pageName){
      Get.toNamed(AppRoutes.repeatPage);
    }else{
      assert(false, 'error in getAlarmDetailPage of AlarmDetailFactory');
    }
  }
}