import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_alarm_clock/ui/alarm_detail_page/ring/controller/ring_radio_list_controller.dart';
import 'package:new_alarm_clock/ui/home/widgets/delete_dialog.dart';

class DeleteMusicButton extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return IconButton(
      iconSize: 1150,
      icon: Icon(Icons.refresh_rounded),
      onPressed: () async {
        bool? isDelete = await Get.dialog(DeleteDialog('음악 목록이 삭제됩니다. 초기화하시겠습니까?'));
        if(isDelete == true){
          Get.find<RingRadioListController>().resetMusic();
        }
      },
    );
  }
}
