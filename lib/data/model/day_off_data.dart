import '../../utils/values/string_value.dart';

class DayOffData {
  late int id;
  late DateTime dayOffDate;

  DayOffData({required this.id, required this.dayOffDate});

  factory DayOffData.fromMap(Map<String, dynamic> json) => DayOffData(
      id: json[DatabaseString.columnId],
      dayOffDate: DateTime.parse(json[DatabaseString.columnDayOffDate]));

  Map<String, dynamic> toMap() => {
        DatabaseString.columnId: id,
        DatabaseString.columnDayOffDate: dayOffDate.toIso8601String()
      };
}
