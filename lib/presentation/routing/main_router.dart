import 'package:auto_route/annotations.dart';
import 'package:better_informed_mobile/presentation/page/entry/entry_page.dart';

@AdaptiveAutoRouter(
  routes: [
    AutoRoute(page: EntryPage, initial: true),
  ],
)
class $MainRouter {}
