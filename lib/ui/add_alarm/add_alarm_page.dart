import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:new_alarm_clock/data/database/alarm_provider.dart';
import 'package:new_alarm_clock/data/model/alarm_data.dart';
import 'package:new_alarm_clock/data/shared_preferences/id_shared_preferences.dart';
import 'package:new_alarm_clock/routes/app_routes.dart';
import 'package:new_alarm_clock/ui/add_alarm/controller/alarm_title_text_field_controller.dart';
import 'package:new_alarm_clock/ui/add_alarm/controller/day_of_week_controller.dart';
import 'package:new_alarm_clock/ui/add_alarm/controller/time_spinner_controller.dart';
import 'package:new_alarm_clock/ui/add_alarm/widgets/day_button.dart';
import 'package:new_alarm_clock/ui/add_alarm/widgets/list_tile/alarm_detail_list_tile_factory.dart';
import 'package:new_alarm_clock/ui/add_alarm/widgets/time_spinner.dart';
import 'package:new_alarm_clock/ui/home/controller/alarm_list_controller.dart';
import 'package:new_alarm_clock/utils/enum.dart';
import 'package:new_alarm_clock/utils/values/color_value.dart';
import 'package:get/get.dart';
import 'package:new_alarm_clock/utils/values/my_font_family.dart';
import 'package:new_alarm_clock/utils/values/string_value.dart';

final String toBeAddedIdName = 'toBeAddedId';

//이 페이지로 올때 메인페이지에서 get.to 할때 인자들 넘겨주기(이름, id, 설정한 음악 이름, 등등)
//id만 넘기고 데이터베이스에서 가져오는 것도 괜찮을 듯
class AddAlarmPage extends StatelessWidget {
  String mode = '';
  int alarmId = -1;
  AlarmProvider _alarmProvider = AlarmProvider();
  final AlarmDetailListTileFactory _alarmDetailListTileFactory
    = AlarmDetailListTileFactory();
  final IdSharedPreferences idSharedPreferences = IdSharedPreferences();

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> argFromPreviousPage  = Get.arguments;
    mode = argFromPreviousPage[StringValue.mode];
    alarmId = argFromPreviousPage[StringValue.alarmId];

    var dayController = Get.put(DayOfWeekController());
    Get.put(AlarmTitleTextFieldController());
    Get.put(TimeSpinnerController());
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: ColorValue.appbar,
        foregroundColor: ColorValue.appbarText,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded),
          onPressed: () {
            Get.back();
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: TextButton(
                  onPressed: ()async{
                    //이건 addAlarm일 때
                    if(mode == StringValue.addMode) {
                      Get.find<AlarmListController>().inputAlarm(AlarmData(
                        id: alarmId,
                        alarmType: 'single',
                        title: 'title',
                        alarmDateTime: Get.find<TimeSpinnerController>().
                            alarmDateTime,
                        endDay: DateTime(2045),
                        alarmState: true,
                        folderName: '전체 알람',
                        alarmInterval: 0,
                        dayOff: DateTime(2045),
                        musicBool: false,
                        musicPath: 'path',
                        vibrationBool: false,
                        vibrationName: 'vibName',
                        repeatBool: false,
                        repeatInterval: 0,
                      ));
                    }
                    else if(mode == StringValue.editMode){
                      Get.find<AlarmListController>().updateAlarm(AlarmData(
                        id: alarmId,
                        alarmType: 'single',
                        title: '$alarmId edit이에오',
                        alarmDateTime: Get.find<TimeSpinnerController>().
                            alarmDateTime,
                        endDay: DateTime(2045),
                        alarmState: true,
                        folderName: '전체 알람',
                        alarmInterval: 0,
                        dayOff: DateTime(2045),
                        musicBool: false,
                        musicPath: 'path',
                        vibrationBool: false,
                        vibrationName: 'vibName',
                        repeatBool: false,
                        repeatInterval: 0,
                      ));
                    }
                    else{
                      print('error in 저장 button in AddAlarmPage');
                    }
                    Get.back();
                  },
                  child: Text(
                    '저장',
                    style: TextStyle(
                        fontSize: 1000,
                        color: ColorValue.appbarText,
                        fontWeight: FontWeight.bold,
                      fontFamily: MyFontFamily.mainFontFamily
                    ),
                  )
              ),
            ),
          )
        ],
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
