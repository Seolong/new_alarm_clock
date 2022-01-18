import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:new_alarm_clock/routes/app_pages.dart';
import 'package:new_alarm_clock/routes/app_routes.dart';
import 'package:new_alarm_clock/ui/home/home_page.dart';
import 'package:new_alarm_clock/utils/values/color_value.dart';
import 'package:new_alarm_clock/utils/values/my_font_family.dart';

void main() => runApp(MyApp());



class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: ColorValue.appbar,
    ));
    return GetMaterialApp(
      theme: ThemeData(
        textTheme: TextTheme(
          headline1: TextStyle(fontFamily: MyFontFamily.mainFontFamily),
          headline2: TextStyle(fontFamily: MyFontFamily.mainFontFamily),
          headline3: TextStyle(fontFamily: MyFontFamily.mainFontFamily),
          headline4: TextStyle(fontFamily: MyFontFamily.mainFontFamily),
          headline5: TextStyle(fontFamily: MyFontFamily.mainFontFamily),
          headline6: TextStyle(fontFamily: MyFontFamily.mainFontFamily),
          subtitle1: TextStyle(fontFamily: MyFontFamily.mainFontFamily),
          subtitle2: TextStyle(fontFamily: MyFontFamily.mainFontFamily),
          bodyText1: TextStyle(fontFamily: MyFontFamily.mainFontFamily),
          bodyText2: TextStyle(fontFamily: MyFontFamily.mainFontFamily),
          caption: TextStyle(fontFamily: MyFontFamily.mainFontFamily),
          button: TextStyle(fontFamily: MyFontFamily.mainFontFamily),
          overline: TextStyle(fontFamily: MyFontFamily.mainFontFamily),
        )
      ),
      initialRoute: AppRoutes.home,
      getPages: AppPages.pages,
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,//안하면 timepicker에서 에러
      ],
      supportedLocales: [
        const Locale('en'),
        const Locale('ko'),
        const Locale('zh'),
      ],
      locale: const Locale('ko'),
      home: Home(),
    );
  }
}



