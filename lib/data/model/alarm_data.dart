import 'package:new_alarm_clock/utils/enum.dart';
import 'package:new_alarm_clock/utils/type_converter.dart';
import 'package:new_alarm_clock/utils/values/string_value.dart';

class AlarmData {
  late int id;
  late RepeatMode alarmType; //RepeatMode
  late String? title;
  late DateTime alarmDateTime; //_alarmStartTime
  late DateTime? endDay;
  late bool alarmState;
  late int alarmOrder;
  late String folderName;
  late int alarmInterval;
  late DateTime dayOff;
  late int? monthRepeatDay; //29일은 말일
  late bool musicBool;
  late String musicPath;
  late double musicVolume;
  late bool vibrationBool;
  late VibrationName vibrationName;
  late bool repeatBool;
  late int repeatInterval;
  late int
      repeatNum; //무한 반복은 12로 저장한다. 근데 repeatNum이 3보다 크면 무한 반복인 걸로 판단하는 if문 만들 것

  AlarmData({
    required this.id,
    required this.alarmType,
    this.title,
    required this.alarmDateTime,
    required this.endDay,
    required this.alarmState,
    required this.alarmOrder,
    required this.folderName,
    required this.alarmInterval,
    required this.monthRepeatDay,
    required this.musicBool,
    required this.musicPath,
    required this.musicVolume,
    required this.vibrationBool,
    required this.vibrationName,
    required this.repeatBool,
    required this.repeatInterval,
    required this.repeatNum,
  });

  factory AlarmData.fromMap(Map<String, dynamic> json) => AlarmData(
        id: json[DatabaseString.columnId],
        alarmType: RepeatMode.values.firstWhere(
            (e) => e.toString() == json[DatabaseString.columnAlarmType]),
        title: json[DatabaseString.columnTitle],
        alarmDateTime: DateTime.parse(json[DatabaseString.columnAlarmDateTime]),
        endDay: json[DatabaseString.columnEndDay] == null
            ? null
            : DateTime.parse(json[DatabaseString.columnEndDay]),
        alarmState: TypeConverter.convertIntToBool(
            json[DatabaseString.columnAlarmState]),
        alarmOrder: json[DatabaseString.columnAlarmOrder],
        folderName: json[DatabaseString.columnFolderName],
        alarmInterval: json[DatabaseString.columnAlarmInterval],
        monthRepeatDay: json[DatabaseString.columnMonthRepeatDay],
        musicBool: TypeConverter.convertIntToBool(
            json[DatabaseString.columnMusicBool]),
        musicPath: json[DatabaseString.columnMusicPath],
        musicVolume: json[DatabaseString.columnMusicVolume],
        vibrationBool: TypeConverter.convertIntToBool(
            json[DatabaseString.columnVibrationBool]),
        vibrationName: VibrationName.values.firstWhere(
            (e) => e.toString() == json[DatabaseString.columnVibrationName]),
        repeatBool: TypeConverter.convertIntToBool(
            json[DatabaseString.columnRepeatBool]),
        repeatInterval: json[DatabaseString.columnRepeatInterval],
        repeatNum: json[DatabaseString.columnRepeatNum],
      );

  Map<String, dynamic> toMap() => {
        DatabaseString.columnId: id,
        DatabaseString.columnAlarmType: alarmType.toString(),
        DatabaseString.columnTitle: title,
        DatabaseString.columnAlarmDateTime: alarmDateTime.toIso8601String(),
        DatabaseString.columnEndDay: endDay?.toIso8601String(),
        //null이면 null null이 아니면 endDay.toIso8601String()
        DatabaseString.columnAlarmState:
            TypeConverter.convertBoolToInt(alarmState),
        DatabaseString.columnAlarmOrder: alarmOrder,
        DatabaseString.columnFolderName: folderName,
        DatabaseString.columnAlarmInterval: alarmInterval,
        DatabaseString.columnMonthRepeatDay: monthRepeatDay,
        DatabaseString.columnMusicBool:
            TypeConverter.convertBoolToInt(musicBool),
        DatabaseString.columnMusicPath: musicPath,
        DatabaseString.columnMusicVolume: musicVolume,
        DatabaseString.columnVibrationBool:
            TypeConverter.convertBoolToInt(vibrationBool),
        DatabaseString.columnVibrationName: vibrationName.toString(),
        DatabaseString.columnRepeatBool:
            TypeConverter.convertBoolToInt(repeatBool),
        DatabaseString.columnRepeatInterval: repeatInterval,
        DatabaseString.columnRepeatNum: repeatNum
      };
}
