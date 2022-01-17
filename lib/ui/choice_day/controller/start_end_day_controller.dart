import 'package:get/get.dart';
import 'package:intl/intl.dart';

class StartEndDayController extends GetxController{
  RxMap<String, dynamic> _start = {
    'dateTime' : DateTime.now(),
    'monthDay' : '',
    'year' : ''
  }.obs;

  RxMap<String, dynamic> _end = {
    'dateTime' : DateTime(1),
    'monthDay' : '',
    'year' : ''
  }.obs;

  @override
  void onInit() {
    _start['monthDay'] = DateFormat('MM월 dd일').format(_start['dateTime']);
    _start['year'] = DateFormat('yyyy년').format(_start['dateTime']);
    super.onInit();
  }

  RxMap<String, dynamic> get start => _start;
  RxMap<String, dynamic> get end => _end;

  void setStart(DateTime dateTime){
    _start['dateTime'] = dateTime;
    _start['monthDay'] = DateFormat('MM월 dd일').format(_start['dateTime']);
    _start['year'] = DateFormat('yyyy년').format(_start['dateTime']);
    update();
  }

  void setEnd(DateTime dateTime){
    _end['dateTime'] = dateTime;
    _end['monthDay'] = DateFormat('MM월 dd일').format(_end['dateTime']);
    _end['year'] = DateFormat('yyyy년').format(_end['dateTime']);
    update();
  }


}