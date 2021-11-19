import 'dart:async';

import 'package:better_informed_mobile/presentation/widget/share/base_share.dart';

abstract class BaseShareCompletable implements BaseShare {
  Completer get viewReadyCompleter;
}
