import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:new_alarm_clock/ui/alarm_detail_page/ring/controller/ring_radio_list_controller.dart';
import 'package:new_alarm_clock/ui/home/widgets/delete_dialog.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../global/color_controller.dart';

class DeleteMusicButton extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return IconButton(
      iconSize: 1150,
      icon: Icon(
          Icons.refresh_rounded,
        color: Get.find<ColorController>().colorSet.mainTextColor,
      ),
      onPressed: () async {
        bool? isDelete = await Get.dialog(DeleteDialog(LocaleKeys.resetMusicList.tr()));
        if(isDelete == true){
          Get.find<RingRadioListController>().resetMusic();
        }
      },
    );
  }
}
