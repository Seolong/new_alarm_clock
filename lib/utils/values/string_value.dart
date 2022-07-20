class StringValue {
  static final String editMode = 'edit';
  static final String addMode = 'add';
  static final String mode = 'mode';
  static final String id = 'id';
  static final String beepBeep = '삐빅';
  static final String ringRing = '따르릉';
  static final String folderName = 'folderName';
  static final String skipButtonKey = 'skip_once';
  static final String notificationChannelKey = 'basic';

  static final String ringtone = '알람음';
  static final String vibration = '진동';
  static final String repeat = '반복';

  static final String active = 'active';
  static final String inactive = 'inactive';
}

class DatabaseString {
  static final String tableName = 'alarm';
  static final String weekRepeatTableName = 'week_repeat';
  static final String musicPathTableName = 'music_path';
  static final String alarmFolderTableName = 'alarm_folder';
  static final String dayOffTableName = 'day_off';
  static final String columnId = 'id';
  static final String columnAlarmType = 'alarmType';
  static final String columnTitle = 'title';
  static final String columnAlarmDateTime = 'alarmDateTime';
  static final String columnEndDay = 'endDay';
  static final String columnAlarmState = 'alarmState';
  static final String columnAlarmOrder = 'alarmOrder';
  static final String columnFolderName = 'folderName';
  static final String columnAlarmInterval = 'alarmInterval';
  static final String columnMonthRepeatDay = 'monthRepeatDay';
  static final String columnMusicBool = 'musicBool';
  static final String columnMusicPath = 'musicPath';
  static final String columnMusicVolume = 'musicVolume';
  static final String columnVibrationBool = 'vibrationBool';
  static final String columnVibrationName = 'vibrationName';
  static final String columnRepeatBool = 'repeatBool';
  static final String columnRepeatInterval = 'repeatInterval';
  static final String columnRepeatNum = 'repeatNum';
  static final String columnDayOffDate = 'dayOffDate';
  static final String columnPath = 'path';
}

class DayOfWeekString {
  static final String sunday = 'sunday';
  static final String monday = 'monday';
  static final String tuesday = 'tuesday';
  static final String wednesday = 'wednesday';
  static final String thursday = 'thursday';
  static final String friday = 'friday';
  static final String saturday = 'saturday';
}

// message that user can see
class SystemMessage{
  static final String notWeekMode = '현재 \'주마다 반복 모드\'가 아닙니다.';
  static final String alarmWillGoOffSoon = '곧 알람이 울립니다.';
  static final String skipOnce = '한 번 건너뛰기';
  static final String resetMusicList = '음악 목록을 초기화하시겠습니까?';
}
