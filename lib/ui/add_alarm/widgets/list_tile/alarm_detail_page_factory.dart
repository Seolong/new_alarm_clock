import 'package:new_alarm_clock/routes/app_routes.dart';
import 'package:get/get.dart';

class AlarmDetailPageFactory{

  void getAlarmDetailPage(String pageName){
    switch(pageName){
      case '알람음':
        Get.toNamed(AppRoutes.ringPage);
        break;
      case '진동':
        Get.toNamed(AppRoutes.vibrationPage);
        break;
      case '반복':
        Get.toNamed(AppRoutes.repeatPage);
        break;
      default://error
        assert(false, 'error in getAlarmDetailPage of AlarmDetailFactory');
    }
  }
}