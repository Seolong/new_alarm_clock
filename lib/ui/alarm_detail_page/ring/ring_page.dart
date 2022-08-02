import 'package:flutter/material.dart';
import 'package:new_alarm_clock/ui/alarm_detail_page/ring/controller/ring_radio_list_controller.dart';
import 'package:new_alarm_clock/ui/alarm_detail_page/ring/widget/add_music_button.dart';
import 'package:new_alarm_clock/ui/alarm_detail_page/ring/widget/delete_music_button.dart';
import 'package:new_alarm_clock/ui/alarm_detail_page/ring/widget/ring_radio_list.dart';
import 'package:new_alarm_clock/ui/alarm_detail_page/ring/widget/volume_slider.dart';
import 'package:new_alarm_clock/ui/alarm_detail_page/widget_all/app_bar_title.dart';
import 'package:new_alarm_clock/ui/global/auto_size_text.dart';
import 'package:new_alarm_clock/ui/global/color_controller.dart';
import 'package:new_alarm_clock/utils/values/color_value.dart';
import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';
import 'package:new_alarm_clock/generated/locale_keys.g.dart';
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
          title: AppBarTitle(LocaleKeys.sound.tr()),
          backgroundColor: Get.find<ColorController>().colorSet.mainColor,
        ),
        body: SafeArea(
          minimum: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Column(
            children: [
              GetBuilder<RingRadioListController>(
                builder: (_) => SwitchListTile(
                    title: Container(
                      alignment: Alignment.bottomLeft,
                      height: SizeValue.detailPowerTextHeight,
                      child: AutoSizeText(
                          _.power ? LocaleKeys.on.tr() : LocaleKeys.off.tr(),
                          bold: true,
                          color: _.power ? Get.find<ColorController>().colorSet.mainColor : Colors.grey
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
                  activeColor: Get.find<ColorController>().colorSet.mainColor,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
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
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 7.5),
                child: Divider(thickness: 2.5,),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
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
                                                color: _.power? Get.find<ColorController>().colorSet.mainColor: Colors.grey,
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
                                                  LocaleKeys.soundList.tr(),
                                                  style: TextStyle(
                                                    color: _.power? Get.find<ColorController>().colorSet.mainColor: Colors.grey,
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
                                            child: DeleteMusicButton()),
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
