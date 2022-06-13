import 'package:berbe/localization/st_arabic.dart';
import 'package:berbe/localization/st_chinese.dart';
import 'package:berbe/localization/st_english.dart';
import 'package:berbe/localization/st_french.dart';
import 'package:berbe/localization/st_german.dart';
import 'package:berbe/localization/st_greek.dart';
import 'package:berbe/localization/st_hindi.dart';
import 'package:berbe/localization/st_italian.dart';
import 'package:berbe/localization/st_japanese.dart';
import 'package:berbe/localization/st_portuguese.dart';
import 'package:berbe/localization/st_russian.dart';
import 'package:berbe/localization/st_spanish.dart';
import 'package:berbe/localization/st_thai.dart';
import 'package:berbe/localization/st_turkish.dart';
import 'package:berbe/localization/st_urdu.dart';
import 'package:get/get.dart';

class LocaleString extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': stEnglish,
        'es': stSpanish,
        'fr': stFrench,
        'de': stGerman,
        'it': stItalian,
        'ru': stRussian,
        'hi_IN': stHindi,
        'zh': stChinese,
        'ja': stJapanese,
        'pt': stPortuguese,
        'el': stGreek,
        'tr': stTurkish,
        'th_TH': stThai,
        'ar': stArabic,
        'ur': stUrdu,
      };
}
