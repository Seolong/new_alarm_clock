import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:new_alarm_clock/ui/alarm_detail_page/ring/controller/ring_radio_list_controller.dart';
import 'dart:io';
import '../../../../data/model/music_path_data.dart';
import 'package:get/get.dart';

import '../../../global/color_controller.dart';


class AddMusicButton extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return IconButton(
      iconSize: 1150,
      icon: Icon(
          Icons.add_rounded,
        color: Get.find<ColorController>().colorSet.mainTextColor,
      ),
      onPressed: () async {
        FilePickerResult? result =
        await FilePicker.platform
            .pickFiles(
            type: FileType.audio);

        if (result != null) {
          PlatformFile file =
              result.files.single;
          if (file.path != null) {
            Get.find<RingRadioListController>()
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
    );
  }
}
