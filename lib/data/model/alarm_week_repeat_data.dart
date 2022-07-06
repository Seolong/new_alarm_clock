import 'package:new_alarm_clock/utils/type_converter.dart';
import 'package:new_alarm_clock/utils/values/string_value.dart';

class AlarmWeekRepeatData {
  late int id;
  late bool sunday;
  late bool monday;
  late bool tuesday;
  late bool wednesday;
  late bool thursday;
  late bool friday;
  late bool saturday;

  AlarmWeekRepeatData(
      {required this.id,
      required this.sunday,
      required this.monday,
      required this.tuesday,
      required this.wednesday,
      required this.thursday,
      required this.friday,
      required this.saturday});

  factory AlarmWeekRepeatData.fromMap(Map<String, dynamic> json) =>
      AlarmWeekRepeatData(
          id: json[DatabaseString.columnId],
          sunday: TypeConverter.convertIntToBool(json[DayOfWeekString.sunday]),
          monday: TypeConverter.convertIntToBool(json[DayOfWeekString.monday]),
          tuesday:
              TypeConverter.convertIntToBool(json[DayOfWeekString.tuesday]),
          wednesday:
              TypeConverter.convertIntToBool(json[DayOfWeekString.wednesday]),
          thursday:
              TypeConverter.convertIntToBool(json[DayOfWeekString.thursday]),
          friday: TypeConverter.convertIntToBool(json[DayOfWeekString.friday]),
          saturday:
              TypeConverter.convertIntToBool(json[DayOfWeekString.saturday]));

  Map<String, dynamic> toMap() => {
        DatabaseString.columnId: id,
        DayOfWeekString.sunday: TypeConverter.convertBoolToInt(sunday),
        DayOfWeekString.monday: TypeConverter.convertBoolToInt(monday),
        DayOfWeekString.tuesday: TypeConverter.convertBoolToInt(tuesday),
        DayOfWeekString.wednesday: TypeConverter.convertBoolToInt(wednesday),
        DayOfWeekString.thursday: TypeConverter.convertBoolToInt(thursday),
        DayOfWeekString.friday: TypeConverter.convertBoolToInt(friday),
        DayOfWeekString.saturday: TypeConverter.convertBoolToInt(saturday)
      };
}
