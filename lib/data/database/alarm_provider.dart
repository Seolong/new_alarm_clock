import 'package:new_alarm_clock/data/model/alarm_data.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class AlarmProvider {
  static Database? _database;
  static AlarmProvider? _alarmProvider;
  String tableName = 'alarm';

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
          $columnMusicBool integer not null,
          $columnMusicPath text not null,
          $columnVibrationBool integer not null,
          $columnVibrationName text not null,
          $columnRepeatBool integer not null,
          $columnRepeatInterval integer not null )
        ''');
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

  Future<List<AlarmData>> getAllAlarms() async {
    List<AlarmData> alarmList = [];
    final Database db = await this.database;
    final List<Map<String, dynamic>> alarmMaps =
      await db.query(tableName);

    alarmMaps.forEach((element) {
      var alarmData = AlarmData.fromMap(element);
      alarmList.add(alarmData);
    });

    return await alarmList;
  }

  Future<AlarmData> getAlarmById(int id) async{
    AlarmData alarmData;
    Database db = await this.database;
    var result =  await db.rawQuery(
      'select * from $tableName where $columnId = ?',
      [id]
    );
    alarmData = AlarmData.fromMap(result.first);

    return await alarmData;
  }

  Future<int> deleteAlarm(int id) async {
    Database db = await this.database;
    var countOfdeletedItems = await db.delete(tableName, where: 'id = ?', whereArgs: [id]);
    print('Count of deleted Items is $countOfdeletedItems');
    return countOfdeletedItems;
  }

  void updateAlarm(AlarmData alarmData) async {
    Database db = await this.database;
    await db.update(tableName, alarmData.toMap(),
        where: 'id = ?', whereArgs: [alarmData.id]);
  }
}
