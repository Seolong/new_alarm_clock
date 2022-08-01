import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';
import 'package:new_alarm_clock/generated/locale_keys.g.dart';
import 'package:restart_app/restart_app.dart';
import '../../../../../utils/values/color_value.dart';
import '../../../../global/auto_size_text.dart';
import 'dart:developer';

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
  Color activeColor = ColorValue.activeSwitch;
  Language language = Language.ko;

  @override
  Widget build(BuildContext context) {
    Locale currentLocale = context.locale;
    return InkWell(
      onTap: () async {
        log(currentLocale.languageCode);
        language = currentLocale.languageCode.parseLanguage();
        Get.dialog(
          Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
            insetPadding: EdgeInsets.fromLTRB(10, 20, 10, 25),
            child: Container(
              width: 100,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: getLanguageListTile(context),
              ),
            ),
          ),
        );
      },
      child: Column(
        children: [
          Icon(
            Icons.language,
            size: 50,
            color: Colors.lightBlueAccent,
          ),
          Container(
              height: 20,
              child: AutoSizeText(
                LocaleKeys.language.tr(),
                bold: true,
              )),
        ],
      ),
    );
  }

  List<RadioListTile> getLanguageListTile(BuildContext context) {
    List<RadioListTile<Language>> result = [];

    for (int i = 0; i < Language.values.length; i++) {
      result.add(RadioListTile<Language>(
          title: Text(Language.values[i].parseName()),
          value: Language.values[i],
          groupValue: language,
          onChanged: (newValue) {
            log(newValue!.parseName());
            Get.dialog(Dialog(
              child: Container(
                padding: EdgeInsets.fromLTRB(15, 15, 15, 0),
                height: 175,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                        'You need to restart the app for the changes to take effect.'
                        'Do you want to restart now?'),
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
