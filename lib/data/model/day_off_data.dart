import 'package:new_alarm_clock/data/model/alarm_data.dart';

final columnDayOffDate = 'dayOffDate';

class DayOffData{
  late int id;
  late DateTime dayOffDate;

  DayOffData({
    required this.id,
    required this.dayOffDate
  });

  factory DayOffData.fromMap(Map<String, dynamic> json) =>
      DayOffData(
        id: json[columnId],
        dayOffDate: DateTime.parse(json[columnDayOffDate])
      );

  Map<String, dynamic> toMap() => {
    columnId: id,
    columnDayOffDate: dayOffDate.toIso8601String()
  };
}