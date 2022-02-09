import 'package:new_alarm_clock/utils/type_converter.dart';

final String columnId = 'id';
final String columnAlarmType = 'alarmType';
final String columnTitle = 'title';
final String columnAlarmDateTime = 'alarmDateTime';
final String columnEndDay = 'endDay';
final String columnAlarmState = 'alarmState';
final String columnAlarmPoint = 'alarmPoint';
final String columnFolderName = 'folderName';
final String columnAlarmInterval = 'alarmInterval';
final String columnDayOff = 'dayOff';
final String columnMusicBool = 'musicBool';
final String columnMusicPath = 'musicPath';
final String columnVibrationBool = 'vibrationBool';
final String columnVibrationName = 'vibrationName';
final String columnRepeatBool = 'repeatBool';
final String columnRepeatInterval = 'repeatInterval';

class AlarmData {
  late int id;
  late String alarmType; //RepeatMode
  late String? title;
  late DateTime alarmDateTime; //_alarmStartTime
  late DateTime endDay;
  late bool alarmState;
  //late ?? alarmPoint;
  late String folderName;
  late int alarmInterval;
  late DateTime dayOff;
  late bool musicBool;
  late String musicPath;
  late bool vibrationBool;
  late String vibrationName;
  late bool repeatBool;
  late int repeatInterval;

  AlarmData({
    required this.id,
    required this.alarmType,
    String? this.title,
    required this.alarmDateTime,
    required this.endDay,
    required this.alarmState,
    //required ?? alarmPoint,
    required this.folderName,
    required this.alarmInterval,
    required this.dayOff,
    required this.musicBool,
    required this.musicPath,
    required this.vibrationBool,
    required this.vibrationName,
    required this.repeatBool,
    required this.repeatInterval,
  });

  factory AlarmData.fromMap(Map<String, dynamic> json) =>
      AlarmData(
        id: json[columnId],
        alarmType: json[columnAlarmType],
        title: json[columnTitle],
        //꺼내면 DateTime으로 변환
        alarmDateTime: DateTime.parse(json[columnAlarmDateTime]),
        endDay: DateTime.parse(json[columnEndDay]),
        alarmState: TypeConverter.convertIntToBool(json[columnAlarmState]),
        //alarmPoint: ~~,
        folderName: json[columnFolderName],
        alarmInterval: json[columnAlarmInterval],
        dayOff: DateTime.parse(json[columnDayOff]),
        musicBool: TypeConverter.convertIntToBool(json[columnMusicBool]),
        musicPath: json[columnMusicPath],
        vibrationBool: TypeConverter.convertIntToBool(json[columnVibrationBool]),
        vibrationName: json[columnVibrationName],
        repeatBool: TypeConverter.convertIntToBool(json[columnVibrationBool]),
        repeatInterval: json[columnRepeatInterval],
      );

  Map<String, dynamic> toMap() =>
      {
        columnId: id,
        columnAlarmType: alarmType,
        columnTitle: title,
        //넣을 땐 String으로 변환
        columnAlarmDateTime: alarmDateTime.toIso8601String(),
        columnEndDay: endDay.toIso8601String(),
        columnAlarmState: TypeConverter.convertBoolToInt(alarmState),
        //columnAlarmPoint: alarmPoint,
        columnFolderName: folderName,
        columnAlarmInterval: alarmInterval,
        columnDayOff: dayOff.toIso8601String(),
        columnMusicBool: TypeConverter.convertBoolToInt(musicBool),
        columnMusicPath: musicPath,
        columnVibrationBool: TypeConverter.convertBoolToInt(vibrationBool),
        columnVibrationName: vibrationName,
        columnRepeatBool: TypeConverter.convertBoolToInt(repeatBool),
        columnRepeatInterval: repeatInterval,
      };
}
