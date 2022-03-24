import 'package:new_alarm_clock/utils/values/string_value.dart';

class ConvenienceMethod{
  Map<String, dynamic> getArgToNextPage(String mode, int alarmId, String folderName){
    Map<String, dynamic> result = {
      StringValue.mode: mode,
      StringValue.alarmId: alarmId,
      StringValue.folderName: folderName
    };
    return result;
  }
}