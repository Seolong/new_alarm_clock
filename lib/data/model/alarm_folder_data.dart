import '../../utils/values/string_value.dart';

class AlarmFolderData {
  late String name;

  AlarmFolderData({required this.name});

  factory AlarmFolderData.fromMap(Map<String, dynamic> json) =>
      AlarmFolderData(name: json[DatabaseString.columnFolderName]);

  Map<String, dynamic> toMap() => {DatabaseString.columnFolderName: name};
}
