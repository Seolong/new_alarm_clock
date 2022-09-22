import '../../utils/values/string_value.dart';

class AlarmFolderData {
  late int id;
  late String name;

  AlarmFolderData({required this.id, required this.name});

  factory AlarmFolderData.fromMap(Map<String, dynamic> json) => AlarmFolderData(
        id: json[DatabaseString.columnId],
        name: json[DatabaseString.columnFolderName],
      );

  Map<String, dynamic> toMap() =>
      {DatabaseString.columnId: id, DatabaseString.columnFolderName: name};
}
