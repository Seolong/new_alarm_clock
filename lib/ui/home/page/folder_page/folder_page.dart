import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_alarm_clock/utils/values/my_font_family.dart';

class FolderPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    int? folderCrossAxisCount = Get.width ~/ 100;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
              height: 150,
              alignment: Alignment.center,
              child: Text(
                  '폴더',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  fontFamily: MyFontFamily.mainFontFamily
                ),
              ),
            ),
            Expanded(
              child: Container(
                child: GridView.builder(
                  itemCount: 13, //item 개수
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: folderCrossAxisCount != 0
                        ? folderCrossAxisCount
                        : 1, //1 개의 행에 보여줄 item 개수
                    mainAxisSpacing: 10, //수평 Padding
                    crossAxisSpacing: 10, //수직 Padding
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    //item 의 반목문 항목 형성
                    return GestureDetector(
                      onTap: () { print('$index');},
                      child: Column(
                        children: [
                          Icon(
                              Icons.folder,
                            size: 70,
                          ),
                          Text(
                              '$index',
                            style: TextStyle(
                              fontSize: 20
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}