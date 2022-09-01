import 'package:new_alarm_clock/ui/choice_day/widget/repeat_container.dart';
import 'package:new_alarm_clock/ui/choice_day/widget/repeat_container/day_repeat_container.dart';
import 'package:new_alarm_clock/ui/choice_day/widget/repeat_container/month_repeat_container.dart';
import 'package:new_alarm_clock/ui/choice_day/widget/repeat_container/week_repeat_container.dart';
import 'package:new_alarm_clock/ui/choice_day/widget/repeat_container/year_repeat_container.dart';
import 'package:new_alarm_clock/utils/enum.dart';

class RepeatContainerFactory {
  RepeatContainer? getRepeatContainer(RepeatMode tabName) {
    switch (tabName) {
      case RepeatMode.day:
        return DayRepeatContainer();
      case RepeatMode.week:
        return WeekRepeatContainer();
      case RepeatMode.month:
        return MonthRepeatContainer();
      case RepeatMode.year:
        return YearRepeatContainer();
      default:
        assert(false, 'error in getRepeatContainer in RepeatContainerFactory');
        return null;
    }
  }
}
