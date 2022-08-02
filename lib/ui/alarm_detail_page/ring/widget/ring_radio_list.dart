import 'package:flutter/material.dart';
import 'package:new_alarm_clock/data/model/music_path_data.dart';
import 'package:new_alarm_clock/ui/alarm_detail_page/ring/controller/ring_radio_list_controller.dart';
import 'package:get/get.dart';
import 'package:new_alarm_clock/ui/global/auto_size_text.dart';

import '../../../global/color_controller.dart';

class RingRadioList extends StatelessWidget {

  var ringListView = GetBuilder<RingRadioListController>(builder: (_) {
    return ListView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.fromLTRB(0, 5, 0, 10),
      itemCount: _.pathList.length,
      itemBuilder: (BuildContext context, int index) {
        return SizedBox(
          height: 50,
          child: Row(
            children: [
              Radio(
                value: _.pathList[index].path,
                groupValue: _.selectedMusicPath, //초기값
                onChanged: (String? value) {
                  if (_.power == true) {
                    _.selectedMusicPath = value!;
                  }
                },
                activeColor: _.power? Get.find<ColorController>().colorSet.accentColor: Colors.grey,
              ),
              Expanded(
                child: MaterialButton(
                  minWidth: 0,
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    if (_.power == true) {
                      _.selectedMusicPath = _.pathList[index].path;
                    }
                  },
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: SizedBox(
                      height: 25,
                      child: AutoSizeText(_.getNameOfSong(_.pathList[index].path),
                        color: _.power
                              ? _.textColor['active']
                              : _.textColor['inactive'],
                        ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  });

  @override
  Widget build(BuildContext context) {
    final ringRadioListController = Get.put(RingRadioListController());

    return FutureBuilder<List<MusicPathData>>(
        future: ringRadioListController.pathFutureList,
        builder: (context, AsyncSnapshot<List<MusicPathData>> snapshot) {
          if (snapshot.hasData) {
            return ringListView;
          }
          return Center(
            child: Container(child: Text('Error!')),
          );
        });
  }
}
