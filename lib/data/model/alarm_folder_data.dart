import 'package:new_alarm_clock/data/model/alarm_data.dart';

class AlarmFolderData {
  late String name;

  AlarmFolderData({required this.name});

  factory AlarmFolderData.fromMap(Map<String, dynamic> json) =>
      AlarmFolderData(name: json[columnFolderName]);

  Map<String, dynamic> toMap() => {columnFolderName: name};
}
