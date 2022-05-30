import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/values/color_value.dart';
import '../../../utils/values/size_value.dart';
import '../controller/tab_page_controller.dart';

class HomeBottomNavigationBar extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        canvasColor: ColorValue.mainBackground,
        //중간 더미 BottomNavigationBarItem 터치 효과가 안 보이게 하기 위함
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      child: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 5,
        clipBehavior: Clip.antiAlias,
        child: GetBuilder<TabPageController>(
            builder:(controller) {
              return BottomNavigationBar(
                currentIndex: controller.pageIndex,
                showSelectedLabels: false,
                showUnselectedLabels: false,
                selectedFontSize: 0,
                unselectedFontSize: 0,
                iconSize: ButtonSize.medium,
                onTap: controller.setPageIndex,
                type: BottomNavigationBarType.fixed,
                selectedItemColor: Color(0xff753422),
                unselectedItemColor: ColorValue.tabBarIcon,
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
                      icon: Icon(
                        Icons.volunteer_activism_rounded,
                      ),
                      label: "후원"
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
