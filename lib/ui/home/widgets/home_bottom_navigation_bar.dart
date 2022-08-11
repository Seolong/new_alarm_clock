import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:new_alarm_clock/ui/global/color_controller.dart';

import '../../../utils/values/color_value.dart';
import '../../../utils/values/size_value.dart';
import '../controller/tab_page_controller.dart';

class HomeBottomNavigationBar extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        canvasColor: Get.find<ColorController>().colorSet.backgroundColor,
        //중간 더미 BottomNavigationBarItem 터치 효과가 안 보이게 하기 위함
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      child: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 5,
        clipBehavior: Clip.antiAlias,
        child: GetBuilder<TabPageController>(
            builder:(_) {
              return BottomNavigationBar(
                currentIndex: _.pageIndex,
                showSelectedLabels: false,
                showUnselectedLabels: false,
                selectedFontSize: 0,
                unselectedFontSize: 0,
                iconSize: ButtonSize.medium,
                onTap: _.setPageIndex,
                type: BottomNavigationBarType.fixed,
                selectedItemColor: Get.find<ColorController>().colorSet.deepMainColor,
                unselectedItemColor: Colors.grey,
                items: [
                  BottomNavigationBarItem(
                      icon: Icon(
                        Icons.home_rounded,
                      ),
                      label: "홈"
                  ),
                  BottomNavigationBarItem(
                      icon: Icon(
                        Icons.folder,
                      ),
                      label: "폴더"
                  ),
                  BottomNavigationBarItem(//더미
                      icon: Icon(null),
                      label: "홈"
                  ),
                  BottomNavigationBarItem(
                      icon: SvgPicture.asset(
                        'assets/icons/book.svg',
                        width: 30,
                        height: 30,
                        color:_.pageIndex==3
                            ? Get.find<ColorController>().colorSet.deepMainColor
                        : Colors.grey,
                      ),
                      label: "성경"
                  ),
                  BottomNavigationBarItem(
                      icon: Icon(
                        Icons.more_horiz,
                      ),
                      label: "더보기"
                  ),
                ],
              );}
        ),
      ),
    );
  }
}
