import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:get/get.dart';
import 'package:new_alarm_clock/data/shared_preferences/app_state_shared_preferences.dart';
import 'package:new_alarm_clock/routes/app_pages.dart';
import 'package:new_alarm_clock/service/life_cycle_listener.dart';
import 'package:new_alarm_clock/service/notification_controller.dart';
import 'package:new_alarm_clock/ui/alarm_alarm/alarm_alarm_page.dart';
import 'package:new_alarm_clock/ui/global/color_controller.dart';
import 'package:new_alarm_clock/ui/global/recent_alarm_date_stream_controller.dart';
import 'package:new_alarm_clock/ui/home/controller/alarm_list_controller.dart';
import 'package:new_alarm_clock/ui/home/home_page.dart';
import 'package:new_alarm_clock/utils/values/my_font_family.dart';
import 'package:new_alarm_clock/utils/values/string_value.dart';

final AppStateSharedPreferences _appStateSharedPreferences =
    AppStateSharedPreferences();
String appState = 'main';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  Get.put(RecentAlarmDateStreamController());
  WidgetsBinding.instance.addObserver(LifeCycleListener());

  await AndroidAlarmManager.initialize();
  appState = await _appStateSharedPreferences.getAppState();

  await AwesomeNotifications()
      .initialize('resource://drawable/res_round_alarm_24',
          //null,
          [
        // notification icon
        NotificationChannel(
          channelGroupKey: 'basic_test',
          channelKey: StringValue.notificationChannelKey,
          channelName: 'Basic notifications',
          channelDescription: 'Notification channel for basic tests',
          channelShowBadge: true,
          importance: NotificationImportance.High,
          enableVibration: true,
        ),
      ]);

  Get.put(ColorController());
  runApp(EasyLocalization(
      supportedLocales: const [Locale('ko'), Locale('en')],
      path: 'assets/translations',
      // <-- change the path of the translation files
      fallbackLocale: const Locale('ko'),
      startLocale: const Locale('ko'),
      child: const MyApp()));
}

class MyApp extends StatelessWidget {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(AlarmListController());
    //context.setLocale(Locale('en')); //이거 한번만 하면 뭐 shared 이런 거 할 필요없이 클릭 한번에 끝
    try {
      AwesomeNotifications().setListeners(
          onActionReceivedMethod:
              NotificationController.onActionReceivedMethod);
    } catch (e) {
      if (kDebugMode) {
        print('Say! eeeeee $e');
      }
    }

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: MyApp.navigatorKey,
      theme: ThemeData(
          scaffoldBackgroundColor:
              Get.find<ColorController>().colorSet.backgroundColor,
          appBarTheme: AppBarTheme(
            toolbarHeight: 72,
              systemOverlayStyle: SystemUiOverlayStyle.light,
              backgroundColor: Get.find<ColorController>().colorSet.mainColor,
              foregroundColor:
                  Get.find<ColorController>().colorSet.appBarContentColor,
              titleTextStyle: TextStyle(
                  color:
                      Get.find<ColorController>().colorSet.appBarContentColor,
                  fontFamily: MyFontFamily.mainFontFamily,
                  fontSize: Theme.of(context).textTheme.titleLarge!.fontSize),
              toolbarTextStyle: TextStyle(
                  color:
                      Get.find<ColorController>().colorSet.appBarContentColor)),
          textTheme: TextTheme(
              headlineMedium: Theme.of(context)
                  .textTheme
                  .headlineMedium!
                  .copyWith(fontFamily: MyFontFamily.mainFontFamily),
              titleLarge: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(fontFamily: MyFontFamily.mainFontFamily),
              titleMedium: Theme.of(context).textTheme.titleMedium!.copyWith(
                  fontFamily: MyFontFamily.mainFontFamily,
                  color: Get.find<ColorController>().colorSet.mainTextColor),
              bodyLarge: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(fontFamily: MyFontFamily.mainFontFamily),
              bodyMedium: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(fontFamily: MyFontFamily.mainFontFamily))),
      //initialRoute: AppRoutes.home,
      getPages: AppPages.pages,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      home: appState == 'alarm' ? AlarmAlarmPage() : const Home(),
    );
  }
}
