import 'package:new_alarm_clock/utils/type_converter.dart';

final String columnId = 'id';
final String columnSunday = 'sunday';
final String columnMonday = 'monday';
final String columnTuesday = 'tuesday';
final String columnWednesday = 'wednesday';
final String columnThursday = 'thursday';
final String columnFriday = 'friday';
final String columnSaturday = 'saturday';

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
          id: json[columnId],
          sunday: TypeConverter.convertIntToBool(json[columnSunday]),
          monday: TypeConverter.convertIntToBool(json[columnMonday]),
          tuesday: TypeConverter.convertIntToBool(json[columnTuesday]),
          wednesday: TypeConverter.convertIntToBool(json[columnWednesday]),
          thursday: TypeConverter.convertIntToBool(json[columnThursday]),
          friday: TypeConverter.convertIntToBool(json[columnFriday]),
          saturday: TypeConverter.convertIntToBool(json[columnSaturday]));

  Map<String, dynamic> toMap() => {
        columnId: id,
        columnSunday: TypeConverter.convertBoolToInt(sunday),
        columnMonday: TypeConverter.convertBoolToInt(monday),
        columnTuesday: TypeConverter.convertBoolToInt(tuesday),
        columnWednesday: TypeConverter.convertBoolToInt(wednesday),
        columnThursday: TypeConverter.convertBoolToInt(thursday),
        columnFriday: TypeConverter.convertBoolToInt(friday),
        columnSaturday: TypeConverter.convertBoolToInt(saturday)
      };
}
