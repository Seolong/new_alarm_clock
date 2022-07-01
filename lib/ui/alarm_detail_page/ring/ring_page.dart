import 'package:flutter/material.dart';
import 'package:new_alarm_clock/ui/alarm_detail_page/ring/controller/ring_radio_list_controller.dart';
import 'package:new_alarm_clock/ui/alarm_detail_page/ring/widget/add_music_button.dart';
import 'package:new_alarm_clock/ui/alarm_detail_page/ring/widget/ring_radio_list.dart';
import 'package:new_alarm_clock/ui/alarm_detail_page/ring/widget/volume_slider.dart';
import 'package:new_alarm_clock/ui/alarm_detail_page/widget_all/app_bar_title.dart';
import 'package:new_alarm_clock/ui/global/auto_size_text.dart';
import 'package:new_alarm_clock/utils/values/color_value.dart';
import 'package:get/get.dart';
import 'package:new_alarm_clock/utils/values/size_value.dart';


class RingPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final ringRadioListController = Get.put(RingRadioListController());

    return WillPopScope(
      onWillPop: () {
        ringRadioListController.musicHandler.stopMusic();
        Get.back();
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          foregroundColor: ColorValue.appbarText,
          title: AppBarTitle('알람음'),
          backgroundColor: ColorValue.appbar,
        ),
        body: SafeArea(
          child: Column(
            children: [
              GetBuilder<RingRadioListController>(
                builder: (_) => SwitchListTile(
                    title: Container(
                      alignment: Alignment.bottomLeft,
                      height: SizeValue.detailPowerTextHeight,
                      child: AutoSizeText(
                          _.power ? '사용' : '사용 안 함',
                          bold: true,
                          color: _.power ? ColorValue.activeSwitch : Colors.grey
                      ),
                    ),
                    value: _.power,
                    onChanged: (value) {
                      if (_.power) {
                        _.listTextColor = _.textColor['inactive']!;
                      } else {
                        _.listTextColor = _.textColor['active']!;
                      }

                      _.power = value;
                    },
                  activeColor: ColorValue.activeSwitch,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                child: Divider(),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: Container(
                    height: 55,
                    //padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                    child: Row(
                      children: [
                        //volume icon
                        Expanded(
                          child: Padding(
                            padding:
                                const EdgeInsets.fromLTRB(5, 0, 0, 0),
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: ConstrainedBox(
                                constraints: BoxConstraints(
                                    minWidth: 1, minHeight: 1),
                                child: Icon(
                                  Icons.volume_up_rounded,
                                  size: 1150,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 7,
                          child: VolumeSlider(),
                        ),
                      ],
                    )),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 7.5),
                child: Divider(thickness: 2.5,),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 25),
                  child: Container(
                    padding: EdgeInsets.only(top: 20),
                      decoration: BoxDecoration(
                        color: ColorValue.defaultBackground,
                        borderRadius: BorderRadius.circular(7.5),
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromRGBO(175, 175, 175, 100),
                            spreadRadius: 0,
                            blurRadius: 10,
                            offset: Offset(0, 5), // changes position of shadow
                          )
                        ],
                      ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                          child: Container(
                              height: 55,
                              child: Row(
                                children: [
                                  //note icon
                                  Expanded(
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(5, 0, 0, 0),
                                      child: FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: ConstrainedBox(
                                          constraints: BoxConstraints(
                                              minWidth: 1, minHeight: 1),
                                          child: GetBuilder<RingRadioListController>(
                                            builder: (_) {
                                              return Icon(
                                                Icons.music_note,
                                                size: 1150,
                                                color: _.power? Colors.green: Colors.grey,
                                              );
                                            }
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  //음악 목록 text
                                  Expanded(
                                    flex: 6,
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(0, 10, 0, 10),
                                      child: Container(
                                        height: 30,
                                        padding: EdgeInsets.only(left: 5),
                                        alignment: Alignment.bottomLeft,
                                        child: FittedBox(
                                          fit: BoxFit.scaleDown,
                                          child: ConstrainedBox(
                                            constraints: BoxConstraints(
                                                minWidth: 1, minHeight: 1),
                                            child: GetBuilder<RingRadioListController>(
                                              builder: (_) {
                                                return Text(
                                                  '음악 목록',
                                                  style: TextStyle(
                                                    color: _.power? Colors.green: Colors.grey,
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 1150),
                                                );
                                              }
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: ConstrainedBox(
                                            constraints: BoxConstraints(
                                                minWidth: 1, minHeight: 1),
                                            child: AddMusicButton()),
                                      ),
                                    ),
                                  ),
                                ],
                              )),
                        ),
                        SizedBox(height: 7.5,),
                        Divider(),
                        Expanded(child: Padding(
                          padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                          child: RingRadioList(),
                        )),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
