import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class TabPageController extends GetxController{
  RxInt _pageIndex = 0.obs;

  set pageIndex(int index){
    _pageIndex = index.obs;
    update();
  }

  setPageIndex(int index){
    _pageIndex = index.obs;
    update();
  }

  int get pageIndex => _pageIndex.value;
}