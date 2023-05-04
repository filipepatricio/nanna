import 'package:better_informed_mobile/domain/appearance/use_case/get_preferred_text_scale_factor_use_case.di.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

@singleton
class ArticleTextScaleFactorNotifier extends ChangeNotifier {
  ArticleTextScaleFactorNotifier(this._textScaleFactor);

  @factoryMethod
  static Future<ArticleTextScaleFactorNotifier> create(
    GetPreferredArticleTextScaleFactorUseCase getPreferredArticleTextScaleFactorUseCase,
  ) async {
    final initialScaleFactor = await getPreferredArticleTextScaleFactorUseCase();
    final notifier = ArticleTextScaleFactorNotifier(initialScaleFactor);

    return notifier;
  }

  double _textScaleFactor;

  double get textScaleFactor => _textScaleFactor;

  void updateTextScaleFactor(double textScaleFactor) {
    _textScaleFactor = textScaleFactor;
    notifyListeners();
  }
}
