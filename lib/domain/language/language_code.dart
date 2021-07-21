import 'dart:ui';

enum LanguageCode { en }

const fallbackLanguageCode = LanguageCode.en;

Map<LanguageCode, Locale> availableLocales = {
  LanguageCode.en: const Locale('en'),
};
