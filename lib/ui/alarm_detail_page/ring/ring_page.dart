import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:new_alarm_clock/data/model/music_path_data.dart';
import 'package:new_alarm_clock/ui/alarm_detail_page/ring/controller/ring_radio_list_controller.dart';
import 'package:new_alarm_clock/ui/alarm_detail_page/ring/widget/ring_radio_list.dart';
import 'package:new_alarm_clock/ui/alarm_detail_page/ring/widget/volume_slider.dart';
import 'package:new_alarm_clock/ui/alarm_detail_page/widget_all/app_bar_title.dart';
import 'package:new_alarm_clock/ui/global/auto_size_text.dart';
import 'package:new_alarm_clock/ui/global/divider/rounded_divider.dart';
import 'package:new_alarm_clock/utils/values/color_value.dart';
import 'package:get/get.dart';
import 'dart:io';

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
              Padding(
                padding: const EdgeInsets.fromLTRB(5, 3, 5, 0),
                child: GetBuilder<RingRadioListController>(
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
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                child: RoundedDivider(ColorValue.appbar, 7.5),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                child: ListView(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: Container(
                          height: 55,
                          //padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                          child: Row(
                            children: [
                              //volumn icon
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
                    RoundedDivider(ColorValue.appbar, 7.5),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: Container(
                          height: 55,
                          //padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                          child: Row(
                            children: [
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
                                        Icons.music_note,
                                        size: 1150,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 6,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 10, 0, 10),
                                  child: Container(
                                    height: 30,
                                    padding: EdgeInsets.only(left: 10),
                                    alignment: Alignment.bottomLeft,
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: ConstrainedBox(
                                        constraints: BoxConstraints(
                                            minWidth: 1, minHeight: 1),
                                        child: Text(
                                          '음악 목록',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 1150),
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
                                        child: IconButton(
                                          iconSize: 1150,
                                          icon: Icon(Icons.add_rounded),
                                          onPressed: () async {
                                            FilePickerResult? result =
                                                await FilePicker.platform
                                                    .pickFiles(
                                                        type: FileType.audio);

                                            if (result != null) {
                                              PlatformFile file =
                                                  result.files.single;
                                              if (file.path != null) {
                                                ringRadioListController
                                                    .inputMusicPath(
                                                        MusicPathData(
                                                            path:
                                                                File(file.path!)
                                                                    .absolute
                                                                    .path));
                                              }
                                            } else {
                                              // User canceled the picker
                                            }
                                          },
                                        )),
                                  ),
                                ),
                              ),
                            ],
                          )),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: RingRadioList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
