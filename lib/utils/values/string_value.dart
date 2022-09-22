class StringValue {
  static const String editMode = 'edit';
  static const String addMode = 'add';
  static const String mode = 'mode';
  static const String id = 'id';
  static const String beepBeep = 'Beep-beep';
  static const String ringRing = 'Ring-ring';
  static const String folderName = 'folderName';
  static const String skipButtonKey = 'skip_once';
  static const String notificationChannelKey = 'basic';
  static const String allAlarms = '전체 알람';

  static const String ringtone = '알람음';
  static const String vibration = '진동';
  static const String repeat = '반복';

  static const String active = 'active';
  static const String inactive = 'inactive';
}

class DatabaseString {
  static const String tableName = 'alarm';
  static const String weekRepeatTableName = 'week_repeat';
  static const String musicPathTableName = 'music_path';
  static const String alarmFolderTableName = 'alarm_folder';
  static const String dayOffTableName = 'day_off';
  static const String columnId = 'id';
  static const String columnAlarmType = 'alarmType';
  static const String columnTitle = 'title';
  static const String columnAlarmDateTime = 'alarmDateTime';
  static const String columnEndDay = 'endDay';
  static const String columnAlarmState = 'alarmState';
  static const String columnAlarmOrder = 'alarmOrder';
  static const String columnFolderId = 'folderId';
  static const String columnFolderName = 'folderName';
  static const String columnAlarmInterval = 'alarmInterval';
  static const String columnMonthRepeatDay = 'monthRepeatDay';
  static const String columnMusicBool = 'musicBool';
  static const String columnMusicPath = 'musicPath';
  static const String columnMusicVolume = 'musicVolume';
  static const String columnVibrationBool = 'vibrationBool';
  static const String columnVibrationName = 'vibrationName';
  static const String columnRepeatBool = 'repeatBool';
  static const String columnRepeatInterval = 'repeatInterval';
  static const String columnRepeatNum = 'repeatNum';
  static const String columnDayOffDate = 'dayOffDate';
  static const String columnPath = 'path';
}

class DayOfWeekString {
  static const String sunday = 'sunday';
  static const String monday = 'monday';
  static const String tuesday = 'tuesday';
  static const String wednesday = 'wednesday';
  static const String thursday = 'thursday';
  static const String friday = 'friday';
  static const String saturday = 'saturday';
}

// message that user can see
class SystemMessage {
  static const String notWeekMode = '현재 \'주마다 반복 모드\'가 아닙니다.';
  static const String alarmWillGoOffSoon = '곧 알람이 울립니다.';
  static const String skipOnce = '한 번 건너뛰기';
  static const String resetMusicList = '음악 목록을 초기화하시겠습니까?';
}
