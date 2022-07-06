import 'package:new_alarm_clock/utils/values/string_value.dart';

class MusicPathData {
  late String path; //cache path

  MusicPathData({required this.path});

  factory MusicPathData.fromMap(Map<String, dynamic> json) =>
      MusicPathData(path: json[DatabaseString.columnPath]);

  Map<String, dynamic> toMap() => {DatabaseString.columnPath: path};
}
