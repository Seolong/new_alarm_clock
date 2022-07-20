import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:new_alarm_clock/data/shared_preferences/app_state_shared_preferences.dart';
import 'package:new_alarm_clock/routes/app_pages.dart';
import 'package:new_alarm_clock/routes/app_routes.dart';
import 'package:new_alarm_clock/service/life_cycle_listener.dart';
import 'package:new_alarm_clock/service/notification_controller.dart';
import 'package:new_alarm_clock/ui/alarm_alarm/alarm_alarm_page.dart';
import 'package:new_alarm_clock/ui/global/color_controller.dart';
import 'package:new_alarm_clock/ui/home/controller/alarm_list_controller.dart';
import 'package:new_alarm_clock/ui/home/home_page.dart';
import 'package:new_alarm_clock/utils/values/my_font_family.dart';
import 'package:new_alarm_clock/utils/values/string_value.dart';

final AppStateSharedPreferences _appStateSharedPreferences =
    AppStateSharedPreferences();
String appState = 'main';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  WidgetsBinding.instance.addObserver(LifeCycleListener());

  await AndroidAlarmManager.initialize();
  appState = await _appStateSharedPreferences.getAppState();

  await AwesomeNotifications().initialize(
      'resource://drawable/res_round_alarm_24',
      //null,
      [            // notification icon
        NotificationChannel(
          channelGroupKey: 'basic_test',
          channelKey: StringValue.notificationChannelKey,
          channelName: 'Basic notifications',
          channelDescription: 'Notification channel for basic tests',
          channelShowBadge: true,
          importance: NotificationImportance.High,
          enableVibration: true,
        ),

      ]
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    Get.put(AlarmListController());
    Get.put(ColorController());
    try {
      AwesomeNotifications().setListeners(
          onActionReceivedMethod: NotificationController.onActionReceivedMethod
      );
    } catch (e) {
      print('Say! eeeeee $e');
    }

    return GetMaterialApp(
      navigatorKey: MyApp.navigatorKey,
      theme: ThemeData(
          appBarTheme: AppBarTheme(
            systemOverlayStyle: SystemUiOverlayStyle.dark,
          ),
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
          )),
      initialRoute: AppRoutes.home,
      getPages: AppPages.pages,
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate, //안하면 timepicker에서 에러
      ],
      supportedLocales: [
        const Locale('en'),
        const Locale('ko'),
        const Locale('zh'),
      ],
      locale: const Locale('ko'),
      home: appState == 'alarm' ?
      AlarmAlarmPage()
          : Home(),
    );
  }
}
