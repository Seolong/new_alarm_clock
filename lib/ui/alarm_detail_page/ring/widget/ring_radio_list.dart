import 'package:flutter/material.dart';
import 'package:new_alarm_clock/data/model/music_path_data.dart';
import 'package:new_alarm_clock/ui/alarm_detail_page/ring/controller/ring_radio_list_controller.dart';
import 'package:get/get.dart';
import 'package:new_alarm_clock/utils/values/color_value.dart';

class RingRadioList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ringRadioListController = Get.put(RingRadioListController());

    return FutureBuilder<List<MusicPathData>>(
        future: ringRadioListController.pathFutureList,
        builder: (context, AsyncSnapshot<List<MusicPathData>> snapshot) {
          if (snapshot.hasData) {
            return GetBuilder<RingRadioListController>(builder: (_) {
              return ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.fromLTRB(10, 15, 10, 10),
                itemCount: _.pathList.length + 1,
                itemBuilder: (BuildContext context, int index) {
                  if (index != _.pathList.length) {
                    return RadioListTile(
                        title: Container(
                          alignment: Alignment.bottomLeft,
                          //height: 30,
                          child: Text(_.getNameOfSong(_.pathList[index].path),
                              style: TextStyle(
                                  color: _.power
                                      ? _.textColor['active']
                                      : _.textColor['inactive'],
                              ),),
                        ),
                        value: _.pathList[index].path,
                        groupValue: _.selectedMusicPath, //초기값
                        onChanged: (String? value) {
                          if (_.power == true) {
                            _.selectedMusicPath = value!;
                          }
                        },
                      activeColor: ColorValue.activeSwitch,
                    );
                  } else {
                    return Container(
                      height: 75,
                    );
                  }
                },
              );
            });
          }
          return Center(
            child: Container(child: Text('d')),
          );
        });
  }
}
