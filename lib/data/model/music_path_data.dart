final String columnPath = 'path';

class MusicPathData {
  late String path; //absolutePath

  MusicPathData({required this.path});

  factory MusicPathData.fromMap(Map<String, dynamic> json) =>
      MusicPathData(path: json[columnPath]);

  Map<String, dynamic> toMap() => {columnPath: path};
}
