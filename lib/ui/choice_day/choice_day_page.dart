import 'package:flutter/material.dart';
import 'package:new_alarm_clock/ui/add_alarm/controller/day_of_week_controller.dart';
import 'package:new_alarm_clock/ui/choice_day/controller/interval_text_field_controller.dart';
import 'package:new_alarm_clock/ui/choice_day/controller/month_repeat_day_controller.dart';
import 'package:new_alarm_clock/ui/choice_day/controller/start_end_day_controller.dart';
import 'package:new_alarm_clock/ui/choice_day/widget/one_alarm_container.dart';
import 'package:new_alarm_clock/ui/choice_day/widget/repeat_tab_bar.dart';
import 'package:new_alarm_clock/ui/global/convenience_method.dart';
import 'package:new_alarm_clock/utils/enum.dart';
import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';
import 'package:new_alarm_clock/generated/locale_keys.g.dart';
import '../../utils/values/my_font_family.dart';
import '../../utils/values/size_value.dart';
import '../global/color_controller.dart';
import 'controller/repeat_mode_controller.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';

class ChoiceDayPage extends StatelessWidget {
  final repeatModeController = Get.put(RepeatModeController());

  bool isLessInterValThanZero() {
    return isRepeat() &&
        Get.find<IntervalTextFieldController>().textEditingController.text !=
            '' &&
        int.parse(Get.find<IntervalTextFieldController>()
                .textEditingController
                .text) <=
            0;
  }

  bool isRepeat() {
    return repeatModeController.repeatMode != RepeatMode.single &&
        repeatModeController.repeatMode != RepeatMode.off;
  }

  Future<bool> _onTouchBackButton() async {
    if (repeatModeController.repeatMode == RepeatMode.month &&
        Get.find<MonthRepeatDayController>().monthRepeatDay == null) {
      ConvenienceMethod.showSimpleSnackBar(
          LocaleKeys.youMustChooseRepeatDay.tr());
      return Future.value(false);
    }
    if (isLessInterValThanZero()) {
      ConvenienceMethod.showSimpleSnackBar(
          LocaleKeys.theIntervalMustBeAtLeastOne.tr());
      return Future.value(false);
    }
    if (repeatModeController.repeatMode != RepeatMode.week) {
      Get.find<DayOfWeekController>().resetAllDayButtonStateToFalse();
    } else {
      // RepeatMode.week
      if (Get.find<DayOfWeekController>()
              .dayButtonStateMap
              .containsValue(true) ==
          false) {
        repeatModeController.repeatMode =
            RepeatMode.single; //off로 하면 시작일도 초기화해야 하고 귀찮아져
        Get.find<IntervalTextFieldController>().textEditingController.text = '';
        Get.back();
        return Future.value(false);
      }
    }
    if (!isRepeat()) {
      Get.find<IntervalTextFieldController>().textEditingController.text = '';
      Get.back();
      return Future.value(false);
    }
    Get.find<StartEndDayController>()
        .setStartDayWithBackButton(repeatModeController.repeatMode);
    //Get.find<StartEndDayController>().setEndDayWithBackButton(repeatModeController.repeatMode);
    if (Get.find<IntervalTextFieldController>().textEditingController.text ==
        '') {
      Get.find<IntervalTextFieldController>().textEditingController.text = '1';
    }
    Get.back();
    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onTouchBackButton,
      child: DefaultTabController(
        length: 2,
        initialIndex: repeatModeController.getMainIndex(),
        child: Builder(builder: (context) {
          final tabController = DefaultTabController.of(context)!;
          repeatModeController.setRepeatMode(tabController.index, 0);
          tabController.addListener(() {
            repeatModeController.setRepeatMode(tabController.index, 0);
          });
          return Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              leading: Padding(
                padding:
                    const EdgeInsets.only(left: SizeValue.appBarLeftPadding),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_rounded),
                  onPressed: _onTouchBackButton,
                ),
              ),
              title: Text(LocaleKeys.alarmType.tr()),
            ),
            body: SafeArea(
              minimum: EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                    child: TabBar(
                        isScrollable: true,
                        indicator: MaterialIndicator(
                            color: Get.find<ColorController>()
                                .colorSet
                                .lightMainColor),
                        indicatorColor:
                            Get.find<ColorController>().colorSet.lightMainColor,
                        unselectedLabelColor: Colors.grey,
                        labelStyle: const TextStyle(
                            fontFamily: MyFontFamily.mainFontFamily,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                        labelColor:
                            Get.find<ColorController>().colorSet.lightMainColor,
                        tabs: [
                          Tab(
                            text: LocaleKeys.chooseOne.tr(),
                            height: 50,
                          ),
                          Tab(
                            text: LocaleKeys.repeat.tr(),
                            height: 50,
                          ),
                        ]),
                  ),
                  Divider(
                    height: 5,
                    color: Get.find<ColorController>().colorSet.backgroundColor,
                  ),
                  Flexible(
                    flex: 1,
                    child: TabBarView(children: [
                      const OneAlarmContainer(),
                      RepeatTabBar(),
                    ]),
                  )
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
