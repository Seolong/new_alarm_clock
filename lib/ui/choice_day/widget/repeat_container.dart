import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:new_alarm_clock/routes/app_routes.dart';
import 'package:new_alarm_clock/ui/choice_day/controller/interval_text_field_controller.dart';
import 'package:new_alarm_clock/ui/choice_day/controller/start_end_day_controller.dart';
import 'package:new_alarm_clock/ui/choice_day/widget/repeat_container/widget_all/calendar_container.dart';
import 'package:new_alarm_clock/ui/global/color_controller.dart';
import 'package:new_alarm_clock/ui/global/convenience_method.dart';
import 'package:new_alarm_clock/utils/values/size_value.dart';
import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';
import 'package:new_alarm_clock/generated/locale_keys.g.dart';

import '../../global/gradient_icon.dart';

class RepeatContainer extends StatelessWidget {
  dynamic intervalType;
  late Column bottomColumn;

  RepeatContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(StartEndDayController());
    var intervalTextFieldController = Get.put(IntervalTextFieldController());
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 15, 20, 0),
          child: Material(
            elevation: 1.5,
            color: Get.find<ColorController>().colorSet.backgroundColor,
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            child: Container(
              padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
              height: ButtonSize.large * 2.5,
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
                                  child: GradientIcon(
                                    icon: Icons.today,
                                    size: ButtonSize.large,
                                    gradient: LinearGradient(
                                      colors: <Color>[
                                        Get.find<ColorController>()
                                            .colorSet
                                            .lightMainColor,
                                        Get.find<ColorController>()
                                            .colorSet
                                            .deepMainColor,
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                  ))),
                          Text(
                            _.start['monthDay'],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 15,
                                color: Get.find<ColorController>()
                                    .colorSet
                                    .mainTextColor),
                          ),
                          Text(
                            _.start['year'],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 13,
                                color: Get.find<ColorController>()
                                    .colorSet
                                    .mainTextColor),
                          ),
                        ],
                      ),
                    ),
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
                                  child: GradientIcon(
                                    icon: Icons.event,
                                    size: ButtonSize.large,
                                    gradient: LinearGradient(
                                      colors: <Color>[
                                        Get.find<ColorController>()
                                            .colorSet
                                            .lightMainColor,
                                        Get.find<ColorController>()
                                            .colorSet
                                            .deepMainColor,
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                  ))),
                          Text(
                            _.end['dateTime'] == null
                                ? LocaleKeys.endDate.tr()
                                : _.end['monthDay'],
                            style: TextStyle(
                                fontSize: 15,
                                color: Get.find<ColorController>()
                                    .colorSet
                                    .mainTextColor),
                          ),
                          Text(
                            _.end['dateTime'] == null
                                ? LocaleKeys.notSet.tr()
                                : _.end['year'],
                            style: TextStyle(
                                fontSize: 13,
                                color: Get.find<ColorController>()
                                    .colorSet
                                    .mainTextColor),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Get.toNamed(AppRoutes.dayOffPage);
                          },
                          child: const Icon(
                            Icons.event_busy_rounded,
                            size: ButtonSize.large,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Text(LocaleKeys.setDayOff.tr(),
                            style: const TextStyle(
                                color: Colors.grey, fontSize: 15)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Padding(
          //더 깔쌈한 배치로
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 15),
          child: Material(
            elevation: 1.5,
            color: Get.find<ColorController>().colorSet.backgroundColor,
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
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
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(ButtonSize.xlarge),
                        onTap: () {
                          intervalTextFieldController.plusOne();
                        },
                        child: GradientIcon(
                          icon: Icons.expand_less_rounded,
                          size: ButtonSize.xlarge,
                          gradient: LinearGradient(colors: [
                            Get.find<ColorController>().colorSet.lightMainColor,
                            Get.find<ColorController>().colorSet.deepMainColor
                          ]),
                        ),
                      ),
                    ),
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
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(ButtonSize.xlarge),
                        onTap: () {
                          intervalTextFieldController.minusOne();
                        },
                        child: GradientIcon(
                          icon: Icons.expand_more_rounded,
                          size: ButtonSize.xlarge,
                          gradient: LinearGradient(colors: [
                            Get.find<ColorController>().colorSet.lightMainColor,
                            Get.find<ColorController>().colorSet.deepMainColor
                          ]),
                        ),
                      ),
                    )
                  ],
                ),
                intervalType,
              ],
            ),
          ),
        ),
        bottomColumn,
      ],
    );
  }
}
