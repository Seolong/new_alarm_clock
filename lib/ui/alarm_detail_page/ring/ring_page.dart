import 'package:flutter/material.dart';
import 'package:new_alarm_clock/ui/alarm_detail_page/ring/controller/ring_radio_list_controller.dart';
import 'package:new_alarm_clock/ui/alarm_detail_page/ring/widget/add_music_button.dart';
import 'package:new_alarm_clock/ui/alarm_detail_page/ring/widget/delete_music_button.dart';
import 'package:new_alarm_clock/ui/alarm_detail_page/ring/widget/ring_radio_list.dart';
import 'package:new_alarm_clock/ui/alarm_detail_page/ring/widget/volume_slider.dart';
import 'package:new_alarm_clock/ui/global/auto_size_text.dart';
import 'package:new_alarm_clock/ui/global/color_controller.dart';
import 'package:new_alarm_clock/ui/global/custom_switch.dart';
import 'package:new_alarm_clock/ui/global/custom_switch_list_tile.dart';
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
          leading: Padding(
            padding: const EdgeInsets.only(left: SizeValue.appBarLeftPadding),
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_rounded),
              onPressed: () {
                ringRadioListController.musicHandler.stopMusic();
                Get.back();
              },
            ),
          ),
          title: Text(LocaleKeys.sound.tr()),
        ),
        body: SafeArea(
          minimum: EdgeInsets.symmetric(
              horizontal: SizeValue.alarmDetailPageHorizontalPadding,
              vertical: SizeValue.alarmDetailPageVerticalPadding),
          child: Column(
            children: [
              GetBuilder<RingRadioListController>(
                builder: (_) => CustomSwitchListTile(
                    title: AutoSizeText(
                        _.power ? LocaleKeys.on.tr() : LocaleKeys.off.tr(),
                        bold: true,
                        color: _.power
                            ? Get.find<ColorController>().colorSet.mainColor
                            : Colors.grey),
                    switchWidget: CustomSwitch(
                      touchAreaHeight: 55,
                      value: _.power,
                      onChanged: (value) {
                        _.power = value;
                      },
                      thumbColor: [
                        Get.find<ColorController>().colorSet.lightMainColor,
                        Get.find<ColorController>().colorSet.mainColor,
                        Get.find<ColorController>().colorSet.deepMainColor,
                      ],
                      activeColor:
                          Get.find<ColorController>().colorSet.switchTrackColor,
                    ),
                    value: _.power,
                    onChanged: (bool value) {
                      _.power = value;
                    }),
              ),
              const Divider(),
              Container(
                  height: 55,
                  padding: const EdgeInsets.only(left: 10),
                  child: Row(
                    children: [
                      //volume icon
                      GetBuilder<RingRadioListController>(builder: (_) {
                        return Icon(
                          Icons.volume_up_rounded,
                          size: ButtonSize.medium,
                          color: _.power == true
                              ? Get.find<ColorController>()
                                  .colorSet
                                  .mainTextColor
                              : Colors.grey,
                        );
                      }),
                      Expanded(
                        child: VolumeSlider(),
                      ),
                    ],
                  )),
              const Divider(
                thickness: 2,
              ),
              Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 25),
                  child: Container(
                    padding: const EdgeInsets.only(top: 20),
                    decoration: BoxDecoration(
                      color:
                          Get.find<ColorController>().colorSet.backgroundColor,
                      borderRadius: BorderRadius.circular(7.5),
                      boxShadow: const [
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
                          child: SizedBox(
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
                                          constraints: const BoxConstraints(
                                              minWidth: 1, minHeight: 1),
                                          child: GetBuilder<
                                                  RingRadioListController>(
                                              builder: (_) {
                                            return Icon(
                                              Icons.music_note,
                                              size: 1150,
                                              color: _.power
                                                  ? Get.find<ColorController>()
                                                      .colorSet
                                                      .mainColor
                                                  : Colors.grey,
                                            );
                                          }),
                                        ),
                                      ),
                                    ),
                                  ),
                                  //음악 목록 text
                                  Expanded(
                                    flex: 6,
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 10, 0, 10),
                                      child: Container(
                                        height: 30,
                                        padding: const EdgeInsets.only(left: 5),
                                        alignment: Alignment.bottomLeft,
                                        child: FittedBox(
                                          fit: BoxFit.scaleDown,
                                          child: ConstrainedBox(
                                            constraints: const BoxConstraints(
                                                minWidth: 1, minHeight: 1),
                                            child: GetBuilder<
                                                    RingRadioListController>(
                                                builder: (_) {
                                              return Text(
                                                LocaleKeys.soundList.tr(),
                                                style: TextStyle(
                                                    color: _.power
                                                        ? Get.find<
                                                                ColorController>()
                                                            .colorSet
                                                            .mainColor
                                                        : Colors.grey,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 1150),
                                              );
                                            }),
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
                                            constraints: const BoxConstraints(
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
                                            constraints: const BoxConstraints(
                                                minWidth: 1, minHeight: 1),
                                            child: AddMusicButton()),
                                      ),
                                    ),
                                  ),
                                ],
                              )),
                        ),
                        const SizedBox(
                          height: 7.5,
                        ),
                        const Divider(),
                        Expanded(
                            child: Padding(
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
