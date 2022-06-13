import 'package:berbe/pages/language/language_model.dart';
import 'package:flutter/material.dart';

const listLocale = <Locale>[
  Locale('en', 'US'),
  /*Locale('es', ''),
  Locale('fr', ''),
  Locale('de', ''),
  Locale('it', ''),
  Locale('ru', ''),
  Locale('hi', ''),
  Locale('zh', ''),
  Locale('ja', ''),
  Locale('pt', ''),
  Locale('el', ''),
  Locale('tr', ''),
  Locale('th', ''),
  Locale('ar', ''),
  Locale('ur', '')*/
];


final listLangNameLocale = <LanguageModel>[
  LanguageModel(languageName: "English", langLocal: const Locale('en', '')),
  LanguageModel(languageName: "Español", langLocal: const Locale('es', '')),
  LanguageModel(languageName: "français", langLocal: const Locale('fr', '')),
  LanguageModel(languageName: "Deutsch", langLocal: const Locale('de', '')),
  LanguageModel(languageName: "Italiano", langLocal: const Locale('it', '')),
  LanguageModel(languageName: "русский", langLocal: const Locale('ru', '')),
  LanguageModel(languageName: "हिन्दी", langLocal: const Locale('hi', '')),
  LanguageModel(languageName: "中國人", langLocal: const Locale('zh', '')),
  LanguageModel(languageName: "日本", langLocal: const Locale('ja', '')),
  LanguageModel(languageName: "Português", langLocal: const Locale('pt', '')),
  LanguageModel(languageName: "Ελληνικά", langLocal: const Locale('el', '')),
  LanguageModel(languageName: "Türkçe", langLocal: const Locale('tr', '')),
  LanguageModel(languageName: "ไทย", langLocal: const Locale('th', '')),
  LanguageModel(languageName: "عربى", langLocal: const Locale('ar', '')),
  LanguageModel(languageName: "اردو", langLocal: const Locale('ur', ''))
];

const String cPassAndroidID ="com.app.cpass";
const String cPassIOSID ="488928328";