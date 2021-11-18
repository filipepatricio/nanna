import 'dart:async';

import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/widget/share/base_share_completable.dart';
import 'package:flutter/material.dart';

const _viewHeight = 1280.0;
const _viewWidth = 720.0;

class ShareArticleView extends StatelessWidget implements BaseShareCompletable {
  const ShareArticleView({Key? key}) : super(key: key);

  @override
  Size get size => const Size(_viewWidth, _viewHeight);

  @override
  Completer get viewReadyCompleter => throw UnimplementedError();

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class _Background extends StatelessWidget {
  const _Background({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        height: _viewHeight,
        width: _viewWidth,
        color: AppColors.beige,
        child: Stack(),
      ),
    );
  }
}
