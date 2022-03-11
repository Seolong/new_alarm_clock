import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_alarm_clock/data/database/alarm_provider.dart';
import 'package:new_alarm_clock/data/model/music_path_data.dart';
import 'package:new_alarm_clock/service/music_handler.dart';

class RingRadioListController extends GetxController{
  MusicHandler musicHandler = MusicHandler();
  AlarmProvider _alarmProvider = AlarmProvider();
  String _selectedMusicPath = 'blank'; //절대경로
  RxBool _power = false.obs;//DB에서 가져오기
  Map<String, Color> textColor = {
    'active': Colors.black,
    'inactive': Colors.grey
  };
  RxMap<String, Color> _listTextColor = {'text': Colors.black}.obs;

  Future<List<MusicPathData>>? pathFutureList = null;
  RxList<MusicPathData> pathList = RxList<MusicPathData>();

  RxDouble _volume = 0.7.obs; //addalarmpage에서 edit이면 db에서 받아오기


  set selectedMusicPath(String musicPath){
    _selectedMusicPath = musicPath;
    musicHandler.playMusic(_volume.value, musicPath);

    update();
  }

  String get selectedMusicPath => _selectedMusicPath;

  void initSelectedMusicPathInEdit(String path){
    _selectedMusicPath = path;
    update();
  }


  @override
  void onInit() async{
    pathFutureList = _alarmProvider.getAllMusicPath();
    List<MusicPathData> varPathList = await pathFutureList ?? [];
    pathList = varPathList.obs;

    super.onInit();
  }

  set power(bool value){
    _power(value);
    //switch가 안 움직이면 대개 update()를 빼먹어서다.
    if(_power.value == false){
      musicHandler.stopMusic();
    }
    update();
  }

  bool get power => _power.value;

  set listTextColor(Color color){
    _listTextColor['text'] = color;
    update();
  }

  Color get listTextColor => _listTextColor['text']!;

  void inputMusicPath(MusicPathData musicPathData) async{
    await _alarmProvider.insertMusicPath(musicPathData);
    //List에 없을 때만 List에 넣는다
    if(!pathList.any((e)=>e.path == musicPathData.path)){
      pathList.add(musicPathData);
    }
    pathFutureList = _alarmProvider.getAllMusicPath();
    update();
  }

  String getNameOfSong(String fullName){
    var splitedNameByDirectory = fullName.split('/');
    var name = splitedNameByDirectory[splitedNameByDirectory.length-1];
    var splitedFileName = name.split('.');
    var splitedFileNameWithoutExtension = splitedFileName.getRange(0, splitedFileName.length-1);
    return splitedFileNameWithoutExtension.join('.');
  }

  double get volume => _volume.value;

  set volume(double volume){
    _volume(volume);
    update();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    //노래 끄기
    musicHandler.stopMusic();

    super.onClose();
  }





}