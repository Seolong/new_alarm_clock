import 'package:new_alarm_clock/data/model/alarm_data.dart';
import 'package:new_alarm_clock/data/model/alarm_folder_data.dart';
import 'package:new_alarm_clock/data/model/alarm_week_repeat_data.dart';
import 'package:new_alarm_clock/data/model/day_off_data.dart';
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
  String alarmFolderTableName = 'alarm_folder';
  String dayOffTableName = 'day_off';

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
          $columnEndDay text,
          $columnAlarmState integer not null,
          $columnAlarmOrder integer not null,
          $columnFolderName text not null,
          $columnAlarmInterval integer not null,
          $columnMonthRepeatDay integer,
          $columnMusicBool integer not null,
          $columnMusicPath text not null,
          $columnMusicVolume real not null,
          $columnVibrationBool integer not null,
          $columnVibrationName text not null,
          $columnRepeatBool integer not null,
          $columnRepeatInterval integer not null, 
          $columnRepeatNum integer not null)
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

    await db.execute('''
      create table $alarmFolderTableName(
        $columnFolderName text primary key)
    ''');

    await db.execute('''
      create table $dayOffTableName(
        $columnId int not null,
        $columnDayOffDate text not null,
        primary key ($columnId, $columnDayOffDate))
    ''');

    await db.insert(musicPathTableName, {columnPath: StringValue.beepBeep});
    await db.insert(musicPathTableName, {columnPath: StringValue.ringRing});
    await db.insert(alarmFolderTableName, {columnFolderName: '전체 알람'});
  }

  Future<void> resetDatabase()async {
    Database db = await this.database;
    await db.execute("DROP TABLE IF EXISTS $tableName");
    await db.execute("DROP TABLE IF EXISTS $alarmFolderTableName");
    await db.execute("DROP TABLE IF EXISTS $weekRepeatTableName");
    await db.execute("DROP TABLE IF EXISTS $musicPathTableName");
    await db.execute("DROP TABLE IF EXISTS $dayOffTableName");
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
    final Database db = await this.database;
    //final List<Map<String, dynamic>> alarmMaps = await db.query(tableName);
    final List<Map<String, dynamic>> alarmMaps = await db.rawQuery(
      'select * from $tableName order by $columnAlarmOrder asc'
    );

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

    return insertId;
  }

  Future<int> deleteAlarm(int id) async {
    Database db = await this.database;
    var countOfDeletedItems =
        await db.delete(tableName, where: 'id = ?', whereArgs: [id]);
    print('Count of deleted Items is $countOfDeletedItems');

    AlarmWeekRepeatData? currentAlarmWeekData = await getAlarmWeekDataById(id);
    if(currentAlarmWeekData != null){
      deleteAlarmWeekData(id);
      print('id: $id WeekData is deleted.');
    }

    List<DayOffData> dayOffList = await getDayOffsById(id);
    if (dayOffList.isNotEmpty) {
      for(int i=0; i<dayOffList.length; i++){
        deleteDayOff(dayOffList[i].id, dayOffList[i].dayOffDate);
      }
    }

    //AlarmScheduler.removeAlarm(id);

    return countOfDeletedItems;
  }

  Future<void> updateAlarm(AlarmData alarmData) async {
    Database db = await this.database;
    await db.update(tableName, alarmData.toMap(),
        where: 'id = ?', whereArgs: [alarmData.id]);

    AlarmScheduler.removeAlarm(alarmData.id);
    await AlarmScheduler().newShot(alarmData.alarmDateTime, alarmData.id);
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
    final List<Map<String, dynamic>> musicPathMaps =
        await db.query(musicPathTableName);

    musicPathMaps.forEach((element) {
      var musicPathData = MusicPathData.fromMap(element);
      musicPathList.add(musicPathData);
    });

    return await musicPathList;
  }

  Future<MusicPathData> getMusicPathByName(String path) async {
    MusicPathData musicPathData;
    Database db = await this.database;
    var result = await db.rawQuery(
        'select * from $musicPathTableName where $columnMusicPath = ?', [path]);
    musicPathData = MusicPathData.fromMap(result.first);

    return await musicPathData;
  }

  Future<List<AlarmFolderData>> getAllAlarmFolders() async {
    List<AlarmFolderData> alarmFolderList = [];
    final Database db = await this.database;
    final List<Map<String, dynamic>> alarmFolderMaps =
        await db.query(alarmFolderTableName);

    alarmFolderMaps.forEach((element) {
      var alarmFolderData = AlarmFolderData.fromMap(element);
      alarmFolderList.add(alarmFolderData);
    });

    return await alarmFolderList;
  }

  Future<AlarmFolderData> getAlarmFolderByName(String name) async {
    AlarmFolderData alarmFolderData;
    Database db = await this.database;
    var result = await db.rawQuery(
        'select * from $alarmFolderTableName where $columnFolderName = ?',
        [name]);
    alarmFolderData = AlarmFolderData.fromMap(result.first);

    return await alarmFolderData;
  }

  Future<int> insertAlarmFolder(AlarmFolderData alarmFolderDataData) async {
    Database db = await this.database;
    var insertId = await db.insert(
      alarmFolderTableName,
      alarmFolderDataData.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    print('insert $insertId');

    return insertId;
  }

  //folder 내부 알람까지 삭제
  Future<int> deleteAlarmFolder(String name) async {
    Database db = await this.database;
    var countOfDeletedAlarmItems = await db.delete(
        tableName,
        where: '$columnFolderName = ?',
        whereArgs: [name]
    );
    var countOfDeletedFolderItems = await db.delete(
        alarmFolderTableName,
        where: '$columnFolderName = ?',
        whereArgs: [name]
    );
    print('Count of deleted Folder Items is $countOfDeletedFolderItems'
        '\nCount of deleted Alarm Items is $countOfDeletedAlarmItems');

    return countOfDeletedFolderItems;
  }

  Future<void> updateAlarmFolder(AlarmFolderData alarmFolderData) async {
    Database db = await this.database;
    await db.update(tableName, alarmFolderData.toMap(),
        where: '$columnFolderName = ?', whereArgs: [alarmFolderData.name]);
  }

  Future<List<DayOffData>> getAllDayOff() async {
    List<DayOffData> dayOffDataList = [];
    final Database db = await this.database;
    final List<Map<String, dynamic>> dayOffDataMaps =
    await db.query(dayOffTableName);

    dayOffDataMaps.forEach((element) {
      var dayOffData = DayOffData.fromMap(element);
      dayOffDataList.add(dayOffData);
    });

    return await dayOffDataList;
  }

  Future<List<DayOffData>> getDayOffsById(int id) async {
    List<DayOffData> dayOffDataList = [];
    final Database db = await this.database;
    final List<Map<String, dynamic>> dayOffDataMaps =
    await db.query(dayOffTableName);

    dayOffDataMaps.forEach((element) {
      var dayOffData = DayOffData.fromMap(element);
      if (dayOffData.id == id) {
        dayOffDataList.add(dayOffData);
      }
    });

    return await dayOffDataList;
  }

  Future<int> insertDayOff(DayOffData dayOffData) async {
    Database db = await this.database;
    var insertId = await db.insert(
      dayOffTableName,
      dayOffData.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    print('insert $insertId');

    return insertId;
  }

  Future<int> deleteDayOff(int id, DateTime dayOff) async {
    Database db = await this.database;
    String dayOffString = dayOff.toIso8601String();
    var countOfDeletedItems =
      await db.rawDelete('delete from $dayOffTableName where $columnId = ? and $columnDayOffDate = ?',
        [id, dayOffString]);
    //rawDelete('DELETE FROM Test WHERE name = ?', ['another name']);
    print('Count of deleted Items is $countOfDeletedItems');
    return countOfDeletedItems;
  }
}
