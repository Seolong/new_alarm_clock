import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:new_alarm_clock/data/database/alarm_provider.dart';
import 'package:new_alarm_clock/data/model/alarm_data.dart';
import 'package:new_alarm_clock/ui/global/alarm_item/alarm_item.dart';
import 'package:new_alarm_clock/ui/home/controller/alarm_list_controller.dart';
import 'package:new_alarm_clock/utils/values/color_value.dart';
import 'package:new_alarm_clock/utils/values/my_font_family.dart';
import 'package:get/get.dart';

class InnerHomePage extends StatelessWidget {
  String currentFolderName = '전체 알람';
  late Future<List<AlarmData>> _alarmFutureData;
  AlarmProvider alarmProvider = AlarmProvider();

  InnerHomePage(){
    alarmProvider.initializeDatabase();
    _alarmFutureData = AlarmProvider().getAllAlarms();
  }

  @override
  Widget build(BuildContext context) {
    var alarmListController = Get.put(AlarmListController());
    return Scaffold(
      backgroundColor: ColorValue.mainBackground,
      extendBody: true,
      body: Column(
        children: [
          Container(
            height: 65,
            padding: EdgeInsets.fromLTRB(22.5, 15, 20, 12.5),
            alignment: Alignment.centerLeft,
            //색 지정 안 하면 알람 스크롤할 때 알람이 비쳐보이더라
            decoration: BoxDecoration(
                color: ColorValue.mainBackground,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(15),
                bottomRight: Radius.circular(15),
              )
            ),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                currentFolderName,
                style: TextStyle(
                  fontSize: 1000,
                  color: Colors.black54,
                  fontFamily: MyFontFamily.mainFontFamily,
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
          ),

        Expanded(
          child: FutureBuilder<List<AlarmData>>(
            future: alarmListController.alarmFutureList,
            builder: (context, AsyncSnapshot<List<AlarmData>> snapshot) {
              if(snapshot.hasData) {
                    return GetBuilder<AlarmListController>(builder: (_) {
                      return ListView.separated(
                        shrinkWrap: true,
                        padding: EdgeInsets.fromLTRB(10, 15, 10, 10),
                        itemCount: _.alarmList.length + 1,
                        itemBuilder: (BuildContext context, int index) {
                          if(index == _.alarmList.length){
                            return Container(height: 75,);
                          }
                          return AlarmItem(
                              id: _.alarmList[index].id,
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) =>
                            Container(height: 15,),
                      );
                    });
                  }
              return Center(
                child: Text(
                  'x',
                  style: TextStyle(color: Colors.white),
                ),
              );
                }
          ),
        ),
        ],
      ),
    );
  }
}
