import 'package:new_alarm_clock/data/model/alarm_data.dart';
import 'package:new_alarm_clock/data/model/alarm_week_repeat_data.dart';
import 'package:new_alarm_clock/data/model/music_path_data.dart';
import 'package:new_alarm_clock/service/alarm_scheduler.dart';
import 'package:new_alarm_clock/utils/values/string_value.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class AlarmProvider {
  static Database? _database;
  static AlarmProvider? _alarmProvider;
  String tableName = 'alarm';
  String weekRepeatTableName = 'week_repeat';
  String musicPathTableName = 'music_path';

  AlarmProvider._createInstance();

  factory AlarmProvider() {
    if (_alarmProvider == null) {
      _alarmProvider = AlarmProvider._createInstance();
    }
    return _alarmProvider!;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database!;
  }

  // Future _onConfigure(Database db) async {
  //   // Add support for cascade delete
  //   // Let's use FOREIGN KEY constraints
  //   await db.execute('PRAGMA foreign_keys = ON');
  // }

  Future _onCreate(Database db, int newVersion) async {
    //alarm alarm_week_repeat의 id는 같은 것(분리한 것)
    await db.execute('''
          create table $tableName ( 
          $columnId integer primary key autoincrement,
          $columnAlarmType text not null,
          $columnTitle text,
          $columnAlarmDateTime text not null,
          $columnEndDay text not null,
          $columnAlarmState integer not null,
          $columnFolderName text not null,
          $columnAlarmInterval integer not null,
          $columnDayOff text not null,
          $columnMonthRepeatDay integer,
          $columnMusicBool integer not null,
          $columnMusicPath text not null,
          $columnMusicVolume real not null,
          $columnVibrationBool integer not null,
          $columnVibrationName text not null,
          $columnRepeatBool integer not null,
          $columnRepeatInterval integer not null )
        ''');

    await db.execute('''
        create table $weekRepeatTableName(
          $columnId integer primary key,
          $columnSunday integer,
          $columnMonday integer,
          $columnTuesday integer,
          $columnWednesday integer,
          $columnThursday integer,
          $columnFriday integer,
          $columnSaturday integer )
    ''');

    await db.execute('''
      create table $musicPathTableName(
        $columnPath text primary key)
    ''');

    await db.insert(musicPathTableName, {columnPath: StringValue.beepBeep});
    await db.insert(musicPathTableName, {columnPath: StringValue.ringRing});
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
    final Database db = await this.database;
    final List<Map<String, dynamic>> alarmMaps = await db.query(tableName);

    alarmMaps.forEach((element) {
      var alarmData = AlarmData.fromMap(element);
      alarmList.add(alarmData);
    });

    return await alarmList;
  }

  Future<AlarmData> getAlarmById(int id) async {
    AlarmData alarmData;
    Database db = await this.database;
    var result =
    await db.rawQuery('select * from $tableName where $columnId = ?', [id]);
    alarmData = AlarmData.fromMap(result.first);

    return await alarmData;
  }

  Future<int> insertAlarm(AlarmData alarmData) async {
    Database db = await this.database;
    var insertId = await db.insert(
      tableName,
      alarmData.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    print('insert $insertId');
    AlarmScheduler().newShot(alarmData.alarmDateTime, alarmData.id);

    return insertId;
  }

  Future<int> deleteAlarm(int id) async {
    Database db = await this.database;
    var countOfdeletedItems =
    await db.delete(tableName, where: 'id = ?', whereArgs: [id]);
    print('Count of deleted Items is $countOfdeletedItems');

    AlarmScheduler.removeAlarm(id);

    return countOfdeletedItems;
  }

  Future<void> updateAlarm(AlarmData alarmData) async {
    Database db = await this.database;
    await db.update(tableName, alarmData.toMap(),
        where: 'id = ?', whereArgs: [alarmData.id]);

    AlarmScheduler.removeAlarm(alarmData.id);
    AlarmScheduler().newShot(alarmData.alarmDateTime, alarmData.id);
  }


  Future<int> insertAlarmWeekData(AlarmWeekRepeatData data) async {
    Database db = await this.database;
    var insertId = await db.insert(
      weekRepeatTableName,
      data.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    print('insert WeekRepeatData of $insertId');

    return insertId;
  }

  Future<AlarmWeekRepeatData?>? getAlarmWeekDataById(int id) async {
    AlarmWeekRepeatData? alarmData;
    Database db = await this.database;
    var result = await db.rawQuery(
        'select * from $weekRepeatTableName where $columnId = ?', [id]);
    if (result.isNotEmpty)
      alarmData = AlarmWeekRepeatData.fromMap(result.first);

    print('$alarmData in getAlarmWeekDataById method of AlarmProvider');
    return await alarmData;
  }


  Future<int> deleteAlarmWeekData(int id) async {
    Database db = await this.database;
    var countOfdeletedItems =
        await db.delete(weekRepeatTableName, where: 'id = ?', whereArgs: [id]);
    print('Count of deleted Items is $countOfdeletedItems');
    return countOfdeletedItems;
  }

  Future<void> updateAlarmWeekData(AlarmWeekRepeatData data) async {
    Database db = await this.database;
    await db.update(weekRepeatTableName, data.toMap(),
        where: 'id = ?', whereArgs: [data.id]);

    //스케줄러 관련 추가
  }
  

  Future<int> insertMusicPath(MusicPathData data) async {
    Database db = await this.database;
    var insertId = await db.insert(
      musicPathTableName,
      data.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    print('insert MusicPathData of $insertId');

    return insertId;
  }

  Future<List<MusicPathData>> getAllMusicPath() async {
    List<MusicPathData> musicPathList = [];
    final Database db = await this.database;
    final List<Map<String, dynamic>> musicPathMaps = await db.query(musicPathTableName);

    musicPathMaps.forEach((element) {
      var musicPathData = MusicPathData.fromMap(element);
      musicPathList.add(musicPathData);
    });

    return await musicPathList;
  }

  Future<MusicPathData> getMusicPathById(String path) async {
    MusicPathData musicPathData;
    Database db = await this.database;
    var result =
    await db.rawQuery('select * from $musicPathTableName where $columnMusicPath = ?', [path]);
    musicPathData = MusicPathData.fromMap(result.first);

    return await musicPathData;
  }
}
