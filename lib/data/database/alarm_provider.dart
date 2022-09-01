import 'package:flutter/foundation.dart';
import 'package:new_alarm_clock/data/model/alarm_data.dart';
import 'package:new_alarm_clock/data/model/alarm_folder_data.dart';
import 'package:new_alarm_clock/data/model/alarm_week_repeat_data.dart';
import 'package:new_alarm_clock/data/model/day_off_data.dart';
import 'package:new_alarm_clock/data/model/music_path_data.dart';
import 'package:new_alarm_clock/utils/values/string_value.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class AlarmProvider {
  static Database? _database;
  static AlarmProvider? _alarmProvider;

  AlarmProvider._createInstance();

  factory AlarmProvider() {
    // if (_alarmProvider == null) {
    //   _alarmProvider = AlarmProvider._createInstance();
    // }
    _alarmProvider ??= AlarmProvider._createInstance();
    return _alarmProvider!;
  }

  Future<Database> get database async {
    _database ??= await initializeDatabase();
    return _database!;
  }

  Future _onCreate(Database db, int newVersion) async {
    //alarm alarm_week_repeat의 id는 같은 것(분리한 것)
    await db.execute('''
          create table ${DatabaseString.tableName} ( 
          ${DatabaseString.columnId} integer primary key autoincrement,
          ${DatabaseString.columnAlarmType} text not null,
          ${DatabaseString.columnTitle} text,
          ${DatabaseString.columnAlarmDateTime} text not null,
          ${DatabaseString.columnEndDay} text,
          ${DatabaseString.columnAlarmState} integer not null,
          ${DatabaseString.columnAlarmOrder} integer not null,
          ${DatabaseString.columnFolderName} text not null,
          ${DatabaseString.columnAlarmInterval} integer not null,
          ${DatabaseString.columnMonthRepeatDay} integer,
          ${DatabaseString.columnMusicBool} integer not null,
          ${DatabaseString.columnMusicPath} text not null,
          ${DatabaseString.columnMusicVolume} real not null,
          ${DatabaseString.columnVibrationBool} integer not null,
          ${DatabaseString.columnVibrationName} text not null,
          ${DatabaseString.columnRepeatBool} integer not null,
          ${DatabaseString.columnRepeatInterval} integer not null, 
          ${DatabaseString.columnRepeatNum} integer not null)
        ''');

    await db.execute('''
        create table ${DatabaseString.weekRepeatTableName}(
          ${DatabaseString.columnId} integer primary key,
          ${DayOfWeekString.sunday} integer,
          ${DayOfWeekString.monday} integer,
          ${DayOfWeekString.tuesday} integer,
          ${DayOfWeekString.wednesday} integer,
          ${DayOfWeekString.thursday} integer,
          ${DayOfWeekString.friday} integer,
          ${DayOfWeekString.saturday} integer )
    ''');

    await db.execute('''
      create table ${DatabaseString.musicPathTableName}(
        ${DatabaseString.columnPath} text primary key)
    ''');

    await db.execute('''
      create table ${DatabaseString.alarmFolderTableName}(
        ${DatabaseString.columnFolderName} text primary key)
    ''');

    await db.execute('''
      create table ${DatabaseString.dayOffTableName}(
        ${DatabaseString.columnId} int not null,
        ${DatabaseString.columnDayOffDate} text not null,
        primary key (${DatabaseString.columnId}, ${DatabaseString.columnDayOffDate}))
    ''');

    await db.insert(DatabaseString.musicPathTableName,
        {DatabaseString.columnPath: StringValue.beepBeep});
    await db.insert(DatabaseString.musicPathTableName,
        {DatabaseString.columnPath: StringValue.ringRing});
    await db.insert(DatabaseString.alarmFolderTableName,
        {DatabaseString.columnFolderName: '전체 알람'});
  }

  Future<void> resetAllTable() async {
    Database db = await database;
    await db.execute("DROP TABLE IF EXISTS ${DatabaseString.tableName}");
    await db
        .execute("DROP TABLE IF EXISTS ${DatabaseString.alarmFolderTableName}");
    await db
        .execute("DROP TABLE IF EXISTS ${DatabaseString.weekRepeatTableName}");
    await db
        .execute("DROP TABLE IF EXISTS ${DatabaseString.musicPathTableName}");
    await db.execute("DROP TABLE IF EXISTS ${DatabaseString.dayOffTableName}");
    await _onCreate(db, 1);
  }

  Future<Database> initializeDatabase() async {
    String path = join(await getDatabasesPath(), 'alarm.db');

    var database = await openDatabase(
      path,
      version: 1,
      //onConfigure: _onConfigure,
      onCreate: _onCreate,
    );
    return database;
  }

  Future<List<AlarmData>> getAllAlarms() async {
    List<AlarmData> alarmList = [];
    final Database db = await database;
    //final List<Map<String, dynamic>> alarmMaps = await db.query(tableName);
    final List<Map<String, dynamic>> alarmMaps = await db.rawQuery(
        'select * from ${DatabaseString.tableName} order by ${DatabaseString.columnAlarmOrder} asc');

    for (var element in alarmMaps) {
      var alarmData = AlarmData.fromMap(element);
      alarmList.add(alarmData);
    }

    return alarmList;
  }

  Future<AlarmData> getAlarmById(int id) async {
    AlarmData alarmData;
    Database db = await database;
    var result = await db.rawQuery(
        'select * from ${DatabaseString.tableName} where ${DatabaseString.columnId} = ?',
        [id]);
    alarmData = AlarmData.fromMap(result.first);

    return alarmData;
  }

  Future<int> insertAlarm(AlarmData alarmData) async {
    Database db = await database;
    var insertId = await db.insert(
      DatabaseString.tableName,
      alarmData.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    if (kDebugMode) {
      print('insert $insertId');
    }

    return insertId;
  }

  Future<int> deleteAlarm(int id) async {
    Database db = await database;
    var countOfDeletedItems = await db
        .delete(DatabaseString.tableName, where: 'id = ?', whereArgs: [id]);

    if (kDebugMode) {
      print('Count of deleted Items is $countOfDeletedItems');
    }

    AlarmWeekRepeatData? currentAlarmWeekData = await getAlarmWeekDataById(id);
    if (currentAlarmWeekData != null) {
      deleteAlarmWeekData(id);
      if (kDebugMode) {
        print('id: $id WeekData is deleted.');
      }
    }

    List<DayOffData> dayOffList = await getDayOffsById(id);
    if (dayOffList.isNotEmpty) {
      for (int i = 0; i < dayOffList.length; i++) {
        deleteDayOff(dayOffList[i].id, dayOffList[i].dayOffDate);
      }
    }

    //AlarmScheduler.removeAlarm(id);

    return countOfDeletedItems;
  }

  Future<void> updateAlarm(AlarmData alarmData) async {
    Database db = await database;
    await db.update(DatabaseString.tableName, alarmData.toMap(),
        where: 'id = ?', whereArgs: [alarmData.id]);
  }

  Future<int> insertAlarmWeekData(AlarmWeekRepeatData data) async {
    Database db = await database;
    var insertId = await db.insert(
      DatabaseString.weekRepeatTableName,
      data.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    if (kDebugMode) {
      print('insert WeekRepeatData of $insertId');
    }

    return insertId;
  }

  Future<AlarmWeekRepeatData?>? getAlarmWeekDataById(int id) async {
    AlarmWeekRepeatData? alarmData;
    Database db = await database;
    var result = await db.rawQuery(
        'select * from ${DatabaseString.weekRepeatTableName} where ${DatabaseString.columnId} = ?',
        [id]);
    if (result.isNotEmpty) {
      alarmData = AlarmWeekRepeatData.fromMap(result.first);
    }

    if (kDebugMode) {
      print('$alarmData in getAlarmWeekDataById method of AlarmProvider');
    }
    return alarmData;
  }

  Future<int> deleteAlarmWeekData(int id) async {
    Database db = await database;
    var countOfDeletedItems = await db.delete(
        DatabaseString.weekRepeatTableName,
        where: 'id = ?',
        whereArgs: [id]);
    if (kDebugMode) {
      print('Count of deleted Items is $countOfDeletedItems');
    }
    return countOfDeletedItems;
  }

  Future<void> updateAlarmWeekData(AlarmWeekRepeatData data) async {
    Database db = await database;
    await db.update(DatabaseString.weekRepeatTableName, data.toMap(),
        where: 'id = ?', whereArgs: [data.id]);
  }

  Future<int> insertMusicPath(MusicPathData data) async {
    Database db = await database;
    var insertId = await db.insert(
      DatabaseString.musicPathTableName,
      data.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    if (kDebugMode) {
      print('insert MusicPathData of $insertId');
    }

    return insertId;
  }

  Future<List<MusicPathData>> getAllMusicPath() async {
    List<MusicPathData> musicPathList = [];
    final Database db = await database;
    final List<Map<String, dynamic>> musicPathMaps =
        await db.query(DatabaseString.musicPathTableName);

    for (var element in musicPathMaps) {
      var musicPathData = MusicPathData.fromMap(element);
      musicPathList.add(musicPathData);
    }

    return musicPathList;
  }

  Future<MusicPathData> getMusicPathByName(String path) async {
    MusicPathData musicPathData;
    Database db = await database;
    var result = await db.rawQuery(
        'select * from ${DatabaseString.musicPathTableName} where ${DatabaseString.columnMusicPath} = ?',
        [path]);
    musicPathData = MusicPathData.fromMap(result.first);

    return musicPathData;
  }

  Future<void> deleteAllMusicPath() async {
    Database db = await database;
    db.rawDelete(
        'delete from ${DatabaseString.musicPathTableName} '
        'where ${DatabaseString.columnPath} != ? and ${DatabaseString.columnPath} != ?',
        [StringValue.beepBeep, StringValue.ringRing]);
  }

  Future<List<AlarmFolderData>> getAllAlarmFolders() async {
    List<AlarmFolderData> alarmFolderList = [];
    final Database db = await database;
    final List<Map<String, dynamic>> alarmFolderMaps =
        await db.query(DatabaseString.alarmFolderTableName);

    for (var element in alarmFolderMaps) {
      var alarmFolderData = AlarmFolderData.fromMap(element);
      alarmFolderList.add(alarmFolderData);
    }

    return alarmFolderList;
  }

  Future<AlarmFolderData> getAlarmFolderByName(String name) async {
    AlarmFolderData alarmFolderData;
    Database db = await database;
    var result = await db.rawQuery(
        'select * from ${DatabaseString.alarmFolderTableName} where ${DatabaseString.columnFolderName} = ?',
        [name]);
    alarmFolderData = AlarmFolderData.fromMap(result.first);

    return alarmFolderData;
  }

  Future<int> insertAlarmFolder(AlarmFolderData alarmFolderDataData) async {
    Database db = await database;
    var insertId = await db.insert(
      DatabaseString.alarmFolderTableName,
      alarmFolderDataData.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    if (kDebugMode) {
      print('insert $insertId');
    }

    return insertId;
  }

  //folder 내부 알람까지 삭제
  Future<int> deleteAlarmFolder(String name) async {
    Database db = await database;
    var countOfDeletedAlarmItems = await db.delete(DatabaseString.tableName,
        where: '${DatabaseString.columnFolderName} = ?', whereArgs: [name]);
    var countOfDeletedFolderItems = await db.delete(
        DatabaseString.alarmFolderTableName,
        where: '${DatabaseString.columnFolderName} = ?',
        whereArgs: [name]);
    if (kDebugMode) {
      print('Count of deleted Folder Items is $countOfDeletedFolderItems'
          '\nCount of deleted Alarm Items is $countOfDeletedAlarmItems');
    }

    return countOfDeletedFolderItems;
  }

  Future<void> updateAlarmFolder(AlarmFolderData alarmFolderData) async {
    Database db = await database;
    await db.update(DatabaseString.tableName, alarmFolderData.toMap(),
        where: '${DatabaseString.columnFolderName} = ?',
        whereArgs: [alarmFolderData.name]);
  }

  Future<List<DayOffData>> getAllDayOff() async {
    List<DayOffData> dayOffDataList = [];
    final Database db = await database;
    final List<Map<String, dynamic>> dayOffDataMaps =
        await db.query(DatabaseString.dayOffTableName);

    for (var element in dayOffDataMaps) {
      var dayOffData = DayOffData.fromMap(element);
      dayOffDataList.add(dayOffData);
    }

    return dayOffDataList;
  }

  Future<List<DayOffData>> getDayOffsById(int id) async {
    List<DayOffData> dayOffDataList = [];
    final Database db = await database;
    final List<Map<String, dynamic>> dayOffDataMaps =
        await db.query(DatabaseString.dayOffTableName);

    for (var element in dayOffDataMaps) {
      var dayOffData = DayOffData.fromMap(element);
      if (dayOffData.id == id) {
        dayOffDataList.add(dayOffData);
      }
    }

    return dayOffDataList;
  }

  Future<int> insertDayOff(DayOffData dayOffData) async {
    Database db = await database;
    var insertId = await db.insert(
      DatabaseString.dayOffTableName,
      dayOffData.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    if (kDebugMode) {
      print('insert $insertId');
    }

    return insertId;
  }

  Future<int> deleteDayOff(int id, DateTime dayOff) async {
    Database db = await database;
    String dayOffString = dayOff.toIso8601String();
    var countOfDeletedItems = await db.rawDelete(
        'delete from ${DatabaseString.dayOffTableName} where ${DatabaseString.columnId} = ? and ${DatabaseString.columnDayOffDate} = ?',
        [id, dayOffString]);
    if (kDebugMode) {
      print('Count of deleted Items is $countOfDeletedItems');
    }
    return countOfDeletedItems;
  }
}
