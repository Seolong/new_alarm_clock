import 'package:flutter/material.dart';
import 'package:new_alarm_clock/data/model/music_path_data.dart';
import 'package:new_alarm_clock/ui/alarm_detail_page/ring/controller/ring_radio_list_controller.dart';
import 'package:get/get.dart';
import 'package:new_alarm_clock/ui/global/custom_radio_list_tile.dart';

import '../../../../utils/values/my_font_family.dart';
import '../../../global/color_controller.dart';

class RingRadioList extends StatelessWidget {
  var ringListView = GetBuilder<RingRadioListController>(builder: (_) {
    return ListView.builder(
      //shrinkWrap: true,
      padding: EdgeInsets.fromLTRB(0, 5, 0, 10),
      itemCount: _.pathList.length,
      itemBuilder: (BuildContext context, int index) {
        return CustomRadioListTile(
          value: _.pathList[index].path,
          groupValue: _.selectedMusicPath,
          onChanged: (String? value) {
            if (_.power == true) {
              _.selectedMusicPath = value!;
            }
          },
          title: _.getNameOfSong(_.pathList[index].path),
          activeColor: _.power
              ? Get.find<ColorController>().colorSet.accentColor
              : Colors.grey,
          titleTextStyle: TextStyle(
              color:
                  _.power ? _.textColor['active']! : _.textColor['inactive']!,
              fontSize: 18,
              fontFamily: MyFontFamily.mainFontFamily),
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
