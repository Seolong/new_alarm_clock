import 'package:flutter/material.dart';
import 'package:new_alarm_clock/ui/global/divider/rounded_divider.dart';
import 'package:new_alarm_clock/utils/values/color_value.dart';
import 'package:get/get.dart';

class RingPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: ColorValue.appbarText,
        title: Text('알람음'),
        backgroundColor: ColorValue.appbar,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(5, 3, 5, 0),
              child: SwitchListTile(
                  title: Text(
                    '사용',
                    style: TextStyle(fontSize: 25),
                  ),
                  value: true,
                  onChanged: null),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
              child: RoundedDivider(ColorValue.appbar, 7.5),
            ),
            Expanded(child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
              child: ListView(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: Container(
                        height: Get.height / 14,
                        //padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                        child: Row(
                          children: [
                            //volumn icon
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: ConstrainedBox(
                                    constraints: BoxConstraints(minWidth:1,minHeight: 1),
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
                              child: Slider(
                                  value: 0.8, //초기값
                                  onChanged: null),
                            ),
                          ],
                        )),
                  ),
                  RoundedDivider(ColorValue.appbar, 7.5),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: Container(
                        height: Get.height / 14,
                        //padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                        child: Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: ConstrainedBox(
                                    constraints: BoxConstraints(minWidth:1,minHeight: 1),
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
                                padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                                child: Align(
                                  alignment: Alignment(-0.8, 0),
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: ConstrainedBox(
                                      constraints: BoxConstraints(minWidth:1,minHeight: 1),
                                      child: Text('음악 목록',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 1150
                                        ),),
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
                                      constraints: BoxConstraints(minWidth:1,minHeight: 1),
                                      child: IconButton(
                                        iconSize: 1150,
                                        icon: Icon(Icons.add_rounded),
                                        onPressed: () {  },
                                      )
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )),
                  ),

                ],
              ),
            )),
            Container(
              height: Get.height / 14 * 8,
              child: ListView(
                children: [
                  Text('2',
                    style: TextStyle(fontSize: 100),),
                  Text('3',
                    style: TextStyle(fontSize: 100),),
                  Text('4',
                    style: TextStyle(fontSize: 100),),
                  Text('5',
                    style: TextStyle(fontSize: 100),),
                  Text('6',
                    style: TextStyle(fontSize: 100),),
                  Text('7',
                    style: TextStyle(fontSize: 100),),
                  Text('8',
                    style: TextStyle(fontSize: 100),),
                  Text('9',
                    style: TextStyle(fontSize: 100),),
                  Text('10',
                    style: TextStyle(fontSize: 100),),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
