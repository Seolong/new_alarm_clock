import 'package:flutter/material.dart';
import 'package:new_alarm_clock/ui/add_alarm/widgets/list_tile/alarm_detail_page_factory.dart';
import 'package:new_alarm_clock/utils/values/my_font_family.dart';

class AlarmDetailListTile extends StatelessWidget {
  Text tileTitle =
      Text('Title', style: TextStyle(fontFamily: MyFontFamily.mainFontFamily));
  Widget tileSubTitle = Text('SubTitle');
  dynamic stateSwitch = Switch(value: true, onChanged: null);
  final AlarmDetailPageFactory alarmDetailPageFactory = AlarmDetailPageFactory();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 77.5,
      child: InkWell(
        onTap: () {
          ////////리스트타일 터치해서 해당 페이지로 넘어가는 메소드.
          /////factory메소드 패턴으로 만든 그거 활용

          alarmDetailPageFactory.getAlarmDetailPage(tileTitle.data!);
        },
        child: Column(
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 7.5, 0, 7.5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        tileTitle,
                        Row(
                          children: [
                            tileSubTitle,
                            Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 12,
                              color: Colors.grey,
                            )
                          ],
                        ),
                      ],
                    ),
                  ),

                  //스위치
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                    child: stateSwitch,
                  ),
                ],
              ),
            ),
            Divider(
              thickness: 1,
            )
          ],
        ),
      ),
    );
  }
}
