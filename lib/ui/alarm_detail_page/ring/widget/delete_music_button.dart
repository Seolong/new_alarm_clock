import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_alarm_clock/ui/alarm_detail_page/ring/controller/ring_radio_list_controller.dart';
import 'package:new_alarm_clock/ui/home/widgets/delete_dialog.dart';
import 'package:new_alarm_clock/utils/values/string_value.dart';

class DeleteMusicButton extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return IconButton(
      iconSize: 1150,
      icon: Icon(Icons.refresh_rounded),
      onPressed: () async {
        bool? isDelete = await Get.dialog(DeleteDialog(SystemMessage.resetMusicList));
        if(isDelete == true){
          Get.find<RingRadioListController>().resetMusic();
        }
      },
    );
  }
}
