import 'package:flutter/material.dart';
import 'package:new_alarm_clock/ui/choice_day/controller/month_repaet_day_controller.dart';
import 'package:new_alarm_clock/ui/global/auto_size_text.dart';
import 'package:new_alarm_clock/utils/values/color_value.dart';
import 'package:new_alarm_clock/utils/values/my_font_family.dart';
import 'package:new_alarm_clock/utils/values/size_value.dart';
import 'package:get/get.dart';

class ChoiceDayButton extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        //GridView 높이에 wrap_content하려 했는데
        //Get.defaultDialog로 구현하려다가 GridView가
        //Container의 width 크기에 맞추지 못하고
        //height까지 설정해야 생성되길래 Get.dialog로 함.
        Get.dialog(
          AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))
            ),
            contentPadding: EdgeInsets.zero,
            title: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                  height: 55,
                    width: Get.width,
                    color: ColorValue.mainBackground,
                    child: AutoSizeText('날짜 선택', bold: true)),
                //Divider(thickness: 2,)
              ],
            ),
            titlePadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
            titleTextStyle: TextStyle(
                color: Colors.black87,
                fontSize: 25,
                fontFamily: MyFontFamily.mainFontFamily,
            ),
            backgroundColor: Colors.white,

            // actions: [
            //   Padding(
            //     padding: const EdgeInsets.fromLTRB(7.5, 0, 7.5, 7.5),
            //     child: Row(
            //       mainAxisAlignment: MainAxisAlignment.end,
            //       children: [
            //         TextButton(
            //             onPressed: () {
            //               Get.back();
            //             },
            //             child: Container(
            //               height: 25,
            //                 child: AutoSizeText('취소', color: Colors.grey,)),
            //             ),
            //       ],
            //     ),
            //   ),
            // ],
            //radius: 10,
            content: Container(
              //height: Get.height / 5 * 3,
              width: Get.width / 5 * 3, //width 필요없는 것 같은데?
              padding: EdgeInsets.fromLTRB(10, 5, 10, 15),
              child: GridView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.all(7.5),
                itemCount: 29, //item 개수
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5, //1 개의 행에 보여줄 item 개수
                  //childAspectRatio: 1 / 2, //item 의 가로 1, 세로 2 의 비율
                  mainAxisSpacing: 7.5, //수평 Padding
                  crossAxisSpacing: 7.5, //수직 Padding
                ),
                itemBuilder: (BuildContext context, int index) {
                  //item 의 반목문 항목 형성
                  return Material(
                    borderRadius:
                      BorderRadius.all(Radius.circular(5)),
                    elevation: 1,
                    child: Ink(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(width: 0.5),
                        borderRadius:
                          BorderRadius.all(Radius.circular(5)),
                      ),
                      child: InkWell(
                        splashColor: Colors.grey,
                        borderRadius:
                          BorderRadius.all(Radius.circular(5)),
                        onTap: (){
                          print(index+1);
                          Get.find<MonthRepeatDayController>().monthRepeatDay = index+1;
                          Get.back();
                        },
                        child: Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(7.5),
                          decoration: BoxDecoration(
                            //color: Colors.white,
                            // border: Border.all(
                            //     width: 1.0
                            // ),
                            borderRadius:
                            BorderRadius.all(Radius.circular(10)),
                          ),
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: ConstrainedBox(
                              constraints:
                              BoxConstraints(minWidth: 1, minHeight: 1),
                              child: Text(
                                index != 28 ? '${index + 1}': '말일',
                                style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 1000,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
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
        color: ColorValue.selectMonthDayButton,
      ),
    );
  }
}
