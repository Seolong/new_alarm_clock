import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:new_alarm_clock/routes/app_routes.dart';
import 'package:new_alarm_clock/ui/add_alarm/controller/alarm_title_text_field_controller.dart';
import 'package:new_alarm_clock/ui/add_alarm/controller/day_of_week_controller.dart';
import 'package:new_alarm_clock/ui/add_alarm/widgets/day_button.dart';
import 'package:new_alarm_clock/ui/add_alarm/widgets/list_tile/alarm_detail_list_tile_factory.dart';
import 'package:new_alarm_clock/ui/add_alarm/widgets/time_spinner.dart';
import 'package:new_alarm_clock/utils/enum.dart';
import 'package:new_alarm_clock/utils/values/color_value.dart';
import 'package:get/get.dart';
import 'package:new_alarm_clock/utils/values/my_font_family.dart';

//이 페이지로 올때 메인페이지에서 get.to 할때 인자들 넘겨주기(이름, id, 설정한 음악 이름, 등등)
//id만 넘기고 데이터베이스에서 가져오는 것도 괜찮을 듯
class AddAlarmPage extends StatelessWidget {
  AlarmDetailListTileFactory _alarmDetailListTileFactory
    = AlarmDetailListTileFactory();

  @override
  Widget build(BuildContext context) {
    var dayController = Get.put(DayOfWeekController());
    Get.put(AlarmTitleTextFieldController());
    return Scaffold(
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: BottomAppBar(
        color: ColorValue.appbar,
        child: Container(
          padding: EdgeInsets.all(Get.height / 80),
          height: Get.height / 14,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minWidth: 1, minHeight: 1),
                    child: IconButton(
                      iconSize: 1000,
                      onPressed: () => {Navigator.pop(context)},
                      icon: Icon(
                        Icons.arrow_back_ios_rounded,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                child: FittedBox(
                    child: IconButton(
                      iconSize: 1000,
                      onPressed: () {

                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.done_rounded,
                        color: Colors.black,
                      ),
                    )),
              )
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: Container(
          color: ColorValue.addAlarmPageBackground,
          padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
          child: Column(
            children: [
              //spinner
              Expanded(flex: 5, child: TimeSpinner(fontSize: 27)),

              Divider(
                thickness: 2,
              ),

              //DaysOfAlarm
              Expanded(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: GetBuilder<DayOfWeekController>(
                          builder: (_) => LayoutBuilder(
                            builder: (BuildContext context,
                                    BoxConstraints constraints) =>
                                Row(
                              children: [
                                Expanded(
                                    child:
                                        DayButton(constraints, DayWeek.Sun, _)),
                                Expanded(
                                    child:
                                        DayButton(constraints, DayWeek.Mon, _)),
                                Expanded(
                                    child:
                                        DayButton(constraints, DayWeek.Tue, _)),
                                Expanded(
                                    child:
                                        DayButton(constraints, DayWeek.Wed, _)),
                                Expanded(
                                    child:
                                        DayButton(constraints, DayWeek.Thu, _)),
                                Expanded(
                                    child:
                                        DayButton(constraints, DayWeek.Fri, _)),
                                Expanded(
                                    child:
                                        DayButton(constraints, DayWeek.Sat, _)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    //ChoiceDayButton
                    FittedBox(
                        fit: BoxFit.scaleDown,
                        child: GestureDetector(
                          child: Icon(
                            Icons.today,
                            color: ColorValue.calendarIcon,
                            size: 1000,
                          ),
                          onTap: () {
                            Get.toNamed(AppRoutes.choiceDayPage);
                          },
                        )),
                  ],
                ),
              ),

              Expanded(
                flex: 1,
                child: Text(
                  '매월 1일 2일',
                ),
              ),

              Expanded(
                flex: 2,
                //TitleTextField
                child: GetBuilder<AlarmTitleTextFieldController>(
                  builder: (_) => TextField(
                    controller: _.textEditingController,
                    onChanged: (value){
                      if(_.textEditingController.text.length != 0){
                        print('length not 0');
                      }
                      else{
                        print('length 0');
                      }
                    },
                    style: TextStyle(
                        fontSize: 24,
                      fontFamily: MyFontFamily.mainFontFamily
                    ),
                    decoration: InputDecoration(
                      labelText: '알람 이름',
                      labelStyle: TextStyle(
                        fontFamily: MyFontFamily.mainFontFamily,
                      ),
                      suffixIcon: _.textEditingController.text.length > 0
                          ? IconButton(
                              icon: Icon(
                                  Icons.clear,
                                color: Colors.black,
                              ),
                              onPressed: () => _.resetField(),
                            ): null // Show the clear button if the text field has something
                    ),
                  ),
                ),
              ),

              _alarmDetailListTileFactory.getDetailListTile(DetailTileName.ring),
              _alarmDetailListTileFactory.getDetailListTile(DetailTileName.vibration),
              _alarmDetailListTileFactory.getDetailListTile(DetailTileName.repeat),
            ],
          ),
        ),
      ),
    );
  }
}
