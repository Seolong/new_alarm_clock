import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_alarm_clock/ui/global/color_controller.dart';
import 'package:new_alarm_clock/ui/global/gradient_icon.dart';

import '../../../utils/values/size_value.dart';
import '../controller/tab_page_controller.dart';

class HomeBottomNavigationBar extends StatelessWidget {
  const HomeBottomNavigationBar({Key? key}) : super(key: key);

  GradientIcon getBottomNavigationActiveIcon(IconData icon) {
    return GradientIcon(
      icon: icon,
      size: ButtonSize.medium,
      gradient: LinearGradient(
        colors: <Color>[
          Get.find<ColorController>().colorSet.lightMainColor,
          Get.find<ColorController>().colorSet.deepMainColor,
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    );
  }

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
        elevation: 15,
        shape: const CircularNotchedRectangle(),
        notchMargin: 5,
        clipBehavior: Clip.antiAlias,
        child: GetBuilder<TabPageController>(builder: (_) {
          return BottomNavigationBar(
            elevation: 15,
            currentIndex: _.pageIndex,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            selectedFontSize: 0,
            unselectedFontSize: 0,
            iconSize: ButtonSize.medium,
            onTap: _.setPageIndex,
            type: BottomNavigationBarType.fixed,
            selectedItemColor:
                Get.find<ColorController>().colorSet.deepMainColor,
            unselectedItemColor: Colors.grey,
            items: [
              BottomNavigationBarItem(
                  activeIcon: getBottomNavigationActiveIcon(Icons.home_rounded),
                  icon: const Icon(
                    Icons.home_rounded,
                  ),
                  label: "홈"),
              BottomNavigationBarItem(
                  activeIcon: getBottomNavigationActiveIcon(Icons.folder),
                  icon: const Icon(
                    Icons.folder,
                  ),
                  label: "폴더"),
              const BottomNavigationBarItem(
                  //더미
                  icon: Icon(null),
                  label: "홈"),
              BottomNavigationBarItem(
                  activeIcon: getBottomNavigationActiveIcon(Icons.book_outlined),
                  icon: const Icon(
                    Icons.book_outlined,
                  ),
                  label: "명언"),
              BottomNavigationBarItem(
                activeIcon: getBottomNavigationActiveIcon(Icons.more_horiz),
                  icon: const Icon(
                    Icons.more_horiz,
                  ),
                  label: "더보기"),
            ],
          );
        }),
      ),
    );
  }
}
