import 'package:new_alarm_clock/ui/add_alarm/widgets/list_tile/alarm_detail_list_tile.dart';
import 'package:new_alarm_clock/ui/add_alarm/widgets/list_tile/repeat_list_tile.dart';
import 'package:new_alarm_clock/ui/add_alarm/widgets/list_tile/ring_list_tile.dart';
import 'package:new_alarm_clock/ui/add_alarm/widgets/list_tile/vibration_list_tile.dart';
import 'package:new_alarm_clock/utils/enum.dart';

class AlarmDetailListTileFactory {
  AlarmDetailListTile getDetailListTile(DetailTileName name) {
    switch (name) {
      case DetailTileName.ring:
        return RingListTile();
      case DetailTileName.vibration:
        return VibrationListTile();
      case DetailTileName.repeat:
        return RepeatListTile();
    }
  }
}
