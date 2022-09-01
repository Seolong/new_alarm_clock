import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:new_alarm_clock/ui/choice_day/controller/month_repeat_day_controller.dart';
import 'package:new_alarm_clock/ui/choice_day/controller/start_end_day_controller.dart';
import 'package:new_alarm_clock/ui/global/auto_size_text.dart';
import 'package:new_alarm_clock/ui/global/color_controller.dart';
import 'package:new_alarm_clock/utils/values/size_value.dart';
import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';
import 'package:new_alarm_clock/generated/locale_keys.g.dart';

class ChoiceDayButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var startEndDayController = Get.put(StartEndDayController());
    return InkWell(
      onTap: () {
        //GridView 높이에 wrap_content하려 했는데
        //Get.defaultDialog로 구현하려다가 GridView가
        //Container의 width 크기에 맞추지 못하고
        //height까지 설정해야 생성되길래 Get.dialog로 함.
        Get.dialog(
          AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
            contentPadding: EdgeInsets.zero,
            title: Container(
                decoration: BoxDecoration(
                  color: Get.find<ColorController>().colorSet.mainColor,
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(10)),
                ),
                padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
                height: 60,
                child: AutoSizeText(
                  LocaleKeys.chooseRepeatDay.tr(),
                  bold: true,
                  color:
                      Get.find<ColorController>().colorSet.appBarContentColor,
                )),
            titlePadding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            backgroundColor:
                Get.find<ColorController>().colorSet.backgroundColor,
            content: Container(
              width: Get.width / 5 * 3,
              padding: const EdgeInsets.fromLTRB(17.5, 10, 17.5, 15),
              child: GridView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.all(7.5),
                itemCount: 29,
                //item 개수
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5, //1 개의 행에 보여줄 item 개수
                  //childAspectRatio: 1 / 2, //item 의 가로 1, 세로 2 의 비율
                  mainAxisSpacing: 7.5, //수평 Padding
                  crossAxisSpacing: 7.5, //수직 Padding
                ),
                itemBuilder: (BuildContext context, int index) {
                  //item 의 반목문 항목 형성
                  return GetBuilder<MonthRepeatDayController>(builder: (_) {
                    return Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Ink(
                        decoration: BoxDecoration(
                          color: Get.find<ColorController>()
                              .colorSet
                              .backgroundColor,
                          //border: Border.all(width: 0.5),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(115)),
                        ),
                        child: InkWell(
                          splashColor: Colors.grey,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(115)),
                          onTap: () {
                            _.monthRepeatDay = index + 1;
                            DateTime startDay =
                                startEndDayController.start['dateTime'];
                            if (startDay.month == DateTime.now().month) {
                              startEndDayController.setStart(
                                  Jiffy(startDay).add(months: 1).dateTime);
                            }
                            Get.back();
                          },
                          child: Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(7.5),
                            decoration: BoxDecoration(
                              color: _.monthRepeatDay != index + 1
                                  ? null
                                  : Get.find<ColorController>()
                                      .colorSet
                                      .mainColor,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(110)),
                            ),
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: ConstrainedBox(
                                constraints: const BoxConstraints(
                                    minWidth: 1, minHeight: 1),
                                child: Text(
                                  index != 28
                                      ? '${index + 1}'
                                      : LocaleKeys.lastDay.tr(),
                                  style: TextStyle(
                                    color: _.monthRepeatDay != index + 1
                                        ? Colors.grey
                                        : Get.find<ColorController>()
                                            .colorSet
                                            .mainTextColor,
                                    fontWeight: _.monthRepeatDay != index + 1
                                        ? null
                                        : FontWeight.bold,
                                    fontSize: 1000,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  });
                },
              ),
            ),
          ),
          //밖 터치하면 dialog가 꺼지는 거
          //barrierDismissible: false,
        );
      },
      child: Icon(
        Icons.apps,
        size: ButtonSize.large,
        color: Get.find<ColorController>().colorSet.mainColor,
      ),
    );
  }
}
