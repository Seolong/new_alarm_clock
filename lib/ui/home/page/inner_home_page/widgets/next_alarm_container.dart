import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:new_alarm_clock/ui/global/recent_alarm_date_stream_controller.dart';
import 'package:new_alarm_clock/utils/values/size_value.dart';
import '../../../../../utils/values/my_font_family.dart';
import '../../../../global/color_controller.dart';

class NextAlarmContainer extends StatelessWidget {
  final double nextAlarmContainerHeight = 70.0;
  final Future<String> _calculation = Future<String>.delayed(
    const Duration(seconds: 2),
    () => 'Data Loaded',
  );

  NextAlarmContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var recentAlarmDateSC = Get.put(RecentAlarmDateStreamController());
    return Stack(children: [
      Container(
        height: nextAlarmContainerHeight * 2.0 - 30,
        color: Colors.transparent,
      ),
      Container(
        height: nextAlarmContainerHeight - 20,
        decoration: BoxDecoration(
            color: Get.find<ColorController>().colorSet.mainColor,
            border: Border.all(
              color: Get.find<ColorController>().colorSet.mainColor,
            ),
            //trick that fill a 1-pixel gap between slivers.
            boxShadow: [
              BoxShadow(
                  color: Get.find<ColorController>().colorSet.mainColor,
                  offset: const Offset(0, -10),
                  spreadRadius: 10)
            ]),
      ),
      Positioned(
        top: nextAlarmContainerHeight / 2.0 - 20,
        left: 10.0,
        right: 10.0,
        child: GetBuilder<RecentAlarmDateStreamController>(builder: (context) {
          return Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                  color: Get.find<ColorController>().colorSet.backgroundColor,
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 4.0,
                      color: Colors.grey[400]!,
                      offset: const Offset(0, 1),
                    )
                  ]),
              height: nextAlarmContainerHeight,
              child:
                  //아! GetxController의 Subscription과
                  //여기 stream(여기다가 넣으면 Subsciption이 만들어지더라)
                  //은 서로 다른 애였다!
                  //그래서 stream을 broad로 안 하면 에러났던 거다!
                  //그래서 여기선 streambuilder 안 쓰기로 함
                  //stream: recentAlarmDateSC.dateStream,
                  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          const Padding(
                            padding: EdgeInsets.fromLTRB(6.0, 0.0, 12.0, 0.0),
                            child: Icon(
                              Icons.event_note_rounded,
                              color: Colors.grey,
                              size: ButtonSize.small,
                            ),
                          ),
                          const VerticalDivider(
                            thickness: 1.0,
                            width: 0.0,
                          ),
                          const SizedBox(
                            width: 12.0,
                          ),
                          FutureBuilder(
                              future: _calculation,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          recentAlarmDateSC
                                              .nextAlarmTimeDifferenceText,
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontFamily:
                                                MyFontFamily.mainFontFamily,
                                            color: Get.find<ColorController>()
                                                .colorSet
                                                .mainTextColor,
                                            //letterSpacing: 0
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          textScaleFactor: 1.0,
                                        ),
                                        recentAlarmDateSC.nextAlarmTitle != ''
                                            ? const SizedBox(
                                                height: 2.5,
                                              )
                                            : const SizedBox.shrink(),
                                        Text(
                                          recentAlarmDateSC.nextAlarmTitle ??
                                              '',
                                          style: TextStyle(
                                              fontSize: recentAlarmDateSC
                                                          .nextAlarmTitle !=
                                                      ''
                                                  ? 14
                                                  : 0,
                                              fontFamily:
                                                  MyFontFamily.mainFontFamily,
                                              color: Colors.grey[600]!),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          textScaleFactor: 1.0,
                                        ),
                                      ],
                                    ),
                                  );
                                } else {
                                  return Expanded(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                            width: 25,
                                            height: 25,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 3,
                                              color: Get.find<ColorController>()
                                                  .colorSet
                                                  .mainColor,
                                            )),
                                      ],
                                    ),
                                  );
                                }
                              }),
                        ],
                      )));
        }),
      ),
    ]);
  }
}
