import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:new_alarm_clock/routes/app_routes.dart';
import 'package:new_alarm_clock/ui/choice_day/controller/interval_text_field_controller.dart';
import 'package:new_alarm_clock/ui/choice_day/controller/start_end_day_controller.dart';
import 'package:new_alarm_clock/ui/choice_day/widget/repeat_container/widget_all/calendar_container.dart';
import 'package:new_alarm_clock/ui/global/auto_size_text.dart';
import 'package:new_alarm_clock/ui/global/color_controller.dart';
import 'package:new_alarm_clock/ui/global/convenience_method.dart';
import 'package:new_alarm_clock/utils/values/size_value.dart';
import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';
import 'package:new_alarm_clock/generated/locale_keys.g.dart';

class RepeatContainer extends StatelessWidget {
  dynamic intervalType;
  late Column bottomColumn;

  RepeatContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(StartEndDayController());
    Get.put(IntervalTextFieldController());
    return ListView(
      children: [
        const Divider(
          height: 0.5,
          thickness: 1,
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
          child: IntrinsicHeight(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: GetBuilder<StartEndDayController>(
                    builder: (_) => Column(
                      children: [
                        InkWell(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(20)),
                            onTap: () async {
                              var dateTime = await Get.dialog(AlertDialog(
                                  contentPadding: EdgeInsets.zero,
                                  content: CalendarContainer(
                                      Get.find<StartEndDayController>()
                                          .start['dateTime'])));
                              if (dateTime != null) {
                                _.setStart(dateTime);
                              }
                            },
                            child: Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Icon(
                                  Icons.today,
                                  size: ButtonSize.large,
                                  color: Get.find<ColorController>()
                                      .colorSet
                                      .accentColor,
                                ))),
                        SizedBox(
                          height: ButtonSize.small - 4,
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: ConstrainedBox(
                                constraints: const BoxConstraints(
                                    minHeight: 1, minWidth: 1),
                                child: Text(
                                  _.start['monthDay'],
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 1000,
                                      color: Get.find<ColorController>()
                                          .colorSet
                                          .mainTextColor),
                                )),
                          ),
                        ),
                        SizedBox(
                          height: ButtonSize.small - 8,
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: ConstrainedBox(
                                constraints: const BoxConstraints(
                                    minHeight: 1, minWidth: 1),
                                child: Text(
                                  _.start['year'],
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 1000,
                                      color: Get.find<ColorController>()
                                          .colorSet
                                          .mainTextColor),
                                )),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const VerticalDivider(
                  width: 3,
                  thickness: 1,
                ),
                Expanded(
                  child: GetBuilder<StartEndDayController>(
                    builder: (_) => Column(
                      children: [
                        InkWell(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(20)),
                            onTap: () async {
                              DateTime? dateTime = await Get.dialog(AlertDialog(
                                  contentPadding: EdgeInsets.zero,
                                  content: CalendarContainer(
                                      _.end['dateTime'] ??
                                          _.start['dateTime'])));
                              if (dateTime == null) {
                                return;
                              }
                              if (dateTime.isBefore(_.start['dateTime'])) {
                                ConvenienceMethod.showSimpleSnackBar(LocaleKeys
                                    .endDateCannotBeforeStartDate
                                    .tr());
                              } else {
                                _.setEnd(dateTime);
                              }
                            },
                            child: Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Icon(
                                  Icons.event,
                                  size: ButtonSize.large,
                                  color: Get.find<ColorController>()
                                      .colorSet
                                      .accentColor,
                                ))),
                        SizedBox(
                          height: ButtonSize.small - 4,
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: ConstrainedBox(
                                constraints: const BoxConstraints(
                                    minHeight: 1, minWidth: 1),
                                child: Text(
                                  _.end['dateTime'] == null
                                      ? LocaleKeys.endDate.tr()
                                      : _.end['monthDay'],
                                  style: TextStyle(
                                      fontSize: 1000,
                                      color: Get.find<ColorController>()
                                          .colorSet
                                          .mainTextColor),
                                )),
                          ),
                        ),
                        SizedBox(
                          height: ButtonSize.small - 8,
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: ConstrainedBox(
                                constraints: const BoxConstraints(
                                    minHeight: 1, minWidth: 1),
                                child: Text(
                                  _.end['dateTime'] == null
                                      ? LocaleKeys.notSet.tr()
                                      : _.end['year'],
                                  style: TextStyle(
                                      fontSize: 1000,
                                      color: Get.find<ColorController>()
                                          .colorSet
                                          .mainTextColor),
                                )),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const Divider(
          thickness: 1,
        ),
        Padding(
          //더 깔쌈한 배치로
          padding: const EdgeInsets.fromLTRB(25, 25, 25, 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(LocaleKeys.every.tr(),
                  style: TextStyle(
                      fontSize: SizeValue.intervalTypeTextSize,
                      color:
                          Get.find<ColorController>().colorSet.mainTextColor)),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    width: SizeValue.repeatTextFieldSize,
                    padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                    child:
                        GetBuilder<IntervalTextFieldController>(builder: (_) {
                      return TextField(
                        keyboardType: TextInputType.number,
                        controller: _.textEditingController,
                        inputFormatters: [
                          //아래에 글자 수 제한도 안보이고 공간도 차지 안하게
                          LengthLimitingTextInputFormatter(5),
                          FilteringTextInputFormatter.digitsOnly //숫자만 입력
                        ],
                        textAlign: TextAlign.end,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.all(0),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          hintText: '1',
                          hintStyle: TextStyle(color: Colors.grey),
                          isDense: true,
                        ),
                        style: TextStyle(
                            fontSize: SizeValue.repeatTextFieldTextSize,
                            color: Get.find<ColorController>()
                                .colorSet
                                .mainTextColor),
                      );
                    }),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 5, 15, 0),
                    child: Text(
                      LocaleKeys.interval.tr(),
                      textAlign: TextAlign.end,
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ),
                ],
              ),
              intervalType,
            ],
          ),
        ),
        bottomColumn,
        Padding(
            padding: const EdgeInsets.only(top: 25),
            child: GestureDetector(
              onTap: () {
                Get.toNamed(AppRoutes.dayOffPage);
              },
              child: Icon(
                Icons.event_busy_rounded,
                size: ButtonSize.large,
                color: Colors.grey,
              ),
            )),
        SizedBox(
            height: 22.5,
            child: AutoSizeText(LocaleKeys.setDayOff.tr(), color: Colors.grey)),
      ],
    );
  }
}
