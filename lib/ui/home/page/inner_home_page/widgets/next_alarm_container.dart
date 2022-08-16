import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:new_alarm_clock/ui/global/recent_alarm_date_stream_controller.dart';
import '../../../../../data/model/alarm_data.dart';
import '../../../../../utils/values/my_font_family.dart';
import '../../../../global/color_controller.dart';

class NextAlarmContainer extends StatelessWidget {
  final double nextAlarmContainerHeight = 70.0;

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
                color: Get.find<ColorController>().colorSet.mainColor)),
      ),
      Positioned(
        top: nextAlarmContainerHeight / 2.0 - 20,
        left: 10.0,
        right: 10.0,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
              color: Get.find<ColorController>().colorSet.appBarContentColor,
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: [
                BoxShadow(blurRadius: 4.0, color: Colors.grey[400]!)
              ]),
          height: nextAlarmContainerHeight,
          child: StreamBuilder<AlarmData>(
            stream: recentAlarmDateSC.dateStream,
            builder: (context, snapshot) {
              //recentAlarmDateSC.differenceTimeNowAndNextAlarm();
              //print('next alarm container builder');
              print(snapshot.data);
              if(snapshot.hasData) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(6.0, 0.0, 12.0, 0.0),
                        child: Icon(
                          Icons.event_note_rounded,
                          color: Colors.grey,
                        ),
                      ),
                      VerticalDivider(
                        thickness: 1.0,
                        width: 0.0,
                      ),
                      SizedBox(
                        width: 12.0,
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              recentAlarmDateSC.nextAlarmTimeDifferenceText,
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: MyFontFamily.mainFontFamily,
                                color: Colors.grey[800]!,
                                //letterSpacing: 0
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textScaleFactor: 1.0,
                            ),
                            SizedBox(
                              height: 2.5,
                            ),
                            Text(
                              recentAlarmDateSC.nextAlarmTitle ?? '',
                              style: TextStyle(
                                  fontSize:
                                      recentAlarmDateSC.nextAlarmTitle != ''
                                          ? 14
                                          : 0,
                                  fontFamily: MyFontFamily.mainFontFamily,
                                  color: Colors.grey[600]!),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textScaleFactor: 1.0,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }else{return Center(
                child: Container(
                  width: 25,
                    height: 25,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                    )
                ),
              );}
            },
          ),
        ),
      ),
    ]);
  }
}
