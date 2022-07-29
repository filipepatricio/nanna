import 'dart:async';

import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/widget/share/base_share_completable.dart';
import 'package:better_informed_mobile/presentation/widget/share/image_load_resolver.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

const _viewHeight = AppDimens.shareHeight;
const _viewWidth = AppDimens.shareWidth;

class EmptyView extends HookWidget implements BaseShareCompletable {
  EmptyView({
    Key? key,
  })  : _baseViewCompleter = Completer(),
        super(key: key);

  final Completer _baseViewCompleter;

  @override
  Size get size => const Size(_viewWidth, _viewHeight);

  @override
  Completer get viewReadyCompleter => _baseViewCompleter;

  @override
  Widget build(BuildContext context) {
    return ImageLoadResolver(
      images: const [],
      completer: _baseViewCompleter,
      child: const SizedBox(),
    );
  }
}
