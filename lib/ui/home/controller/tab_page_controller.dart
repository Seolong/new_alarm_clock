import 'package:get/get.dart';
import 'package:new_alarm_clock/ui/global/alarm_item/controller/selected_alarm_controller.dart';

class TabPageController extends GetxController{
  RxInt _pageIndex = 0.obs;

  set pageIndex(int index){
    _pageIndex = index.obs;
    update();
  }

  setPageIndex(int index){
    Get.closeAllSnackbars();
    Get.find<SelectedAlarmController>().isSelectedMode = false;
    _pageIndex = index.obs;
    update();
  }

  int get pageIndex => _pageIndex.value;
}