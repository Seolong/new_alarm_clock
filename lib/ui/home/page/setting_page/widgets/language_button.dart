import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';
import 'package:new_alarm_clock/generated/locale_keys.g.dart';
import 'package:new_alarm_clock/utils/values/size_value.dart';
import 'package:restart_app/restart_app.dart';
import 'dart:developer';

import '../../../../../utils/values/my_font_family.dart';
import '../../../../global/color_controller.dart';
import '../../../../global/custom_radio_list_tile.dart';

enum Language { ko, en }

extension LanguageExtention on Language {
  String parseName() {
    switch (this) {
      case Language.ko:
        return '한글';
      case Language.en:
        return 'English';
    }
  }

  String parseString() {
    return this.toString().split('.')[1];
  }
}

extension StringLanguageExtension on String {
  Language parseLanguage() {
    switch (this) {
      case 'ko':
        return Language.ko;
      case 'en':
        return Language.en;
      default:
        assert(false, 'LanguageButton: StringLanguageExtension error');
        return Language.en;
    }
  }
}

class LanguageButton extends StatelessWidget {
  double buttonHeight = 37.5;
  double buttonPadding = 7.5;
  double radioRadius = 7.5;
  late double borderRadius = radioRadius + 7.5;
  double borderWidth = 2;
  Language language = Language.ko;

  @override
  Widget build(BuildContext context) {
    Locale currentLocale = context.locale;
    return InkWell(
      borderRadius: BorderRadius.all(Radius.circular(10)),
      onTap: () async {
        log(currentLocale.languageCode);
        language = currentLocale.languageCode.parseLanguage();
        Get.dialog(
          Dialog(
            backgroundColor: Get.find<ColorController>().colorSet.topBackgroundColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
            insetPadding: EdgeInsets.fromLTRB(20, 20, 20, 25),
            child: Container(
              width: 100,
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: getLanguageListTile(context),
              ),
            ),
          ),
        );
      },
      child: ListTile(
          leading: Icon(
            Icons.language,
            size: ButtonSize.medium,
            color: Colors.lightBlueAccent,
          ),
          title: Text(
            LocaleKeys.language.tr(),
            style: Theme.of(context).textTheme.titleLarge
          ),

      ),
    );
  }

  List<CustomRadioListTile> getLanguageListTile(BuildContext context) {
    List<CustomRadioListTile<Language>> result = [];

    for (int i = 0; i < Language.values.length; i++) {
      result.add(CustomRadioListTile<Language>(
          title: Language.values[i].parseName(),
          value: Language.values[i],
          groupValue: language,
          activeColor: Get.find<ColorController>().colorSet.mainColor,
          titleTextStyle: TextStyle(
              color: Get.find<ColorController>().colorSet.mainTextColor,
              fontSize: 18,
              fontFamily: MyFontFamily.mainFontFamily
          ),
          titleFontSize: 20,
          onChanged: (newValue) {
            log(newValue!.parseName());
            Get.dialog(Dialog(
              backgroundColor: Get.find<ColorController>().colorSet.topBackgroundColor,
              child: Container(
                padding: EdgeInsets.fromLTRB(22.5, 22.5, 22.5, 0),
                height: 175,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                        LocaleKeys.doYouWantToRestart.tr(),
                    style: TextStyle(
                      color: Get.find<ColorController>().colorSet.mainTextColor
                    ),),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                            onPressed: () {
                              Get.back();
                            },
                            child: Text(
                              'Cancel',
                              style: TextStyle(color: Colors.grey),
                            )),
                        TextButton(
                            onPressed: () async{
                              language = newValue;
                              await context.setLocale(Locale(newValue.parseString()));
                              Restart.restartApp();
                            },
                            child: Text('Restart')),
                      ],
                    )
                  ],
                ),
              ),
            ));
          }));
    }

    return result;
  }
}
