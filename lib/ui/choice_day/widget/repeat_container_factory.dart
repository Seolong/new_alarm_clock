import 'package:new_alarm_clock/ui/choice_day/widget/repeat_container.dart';
import 'package:new_alarm_clock/ui/choice_day/widget/repeat_container/day_repeat_container.dart';
import 'package:new_alarm_clock/ui/choice_day/widget/repeat_container/month_repeat_container.dart';
import 'package:new_alarm_clock/ui/choice_day/widget/repeat_container/week_repeat_container.dart';
import 'package:new_alarm_clock/utils/enum.dart';

class RepeatContainerFactory{
  RepeatContainer? getRepeatContainer(RepeatTabName tabName){
    switch(tabName){
      case RepeatTabName.day:
        return DayRepeatContainer();
      case RepeatTabName.week:
        return WeekRepeatContainer();
      case RepeatTabName.month:
        return MonthRepeatContainer();
      default:
        assert(false, 'error in getRepeatContainer in RepeatContainerFactory');
    }
  }
}