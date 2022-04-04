import 'package:better_informed_mobile/data/app_link/app_link_data_source.dart';
import 'package:better_informed_mobile/data/auth/app_link/magic_link_parser.di.dart';
import 'package:better_informed_mobile/domain/auth/app_link/auth_app_link_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: AuthAppLinkRepository)
class AuthAppLinkRepositoryImpl implements AuthAppLinkRepository {
  final AppLinkDataSource _appLinkDataSource;
  final MagicLinkParser _magicLinkParser;

  bool _initialLinkHandled = false;

  AuthAppLinkRepositoryImpl(
    this._appLinkDataSource,
    this._magicLinkParser,
  );

  @override
  Stream<String> subscribeForMagicLinkToken() async* {
    final initialLink = _initialLinkHandled ? null : await _appLinkDataSource.getInitialAction();

    try {
      if (initialLink != null) {
        yield _magicLinkParser.parseMagicLink(initialLink);
        _initialLinkHandled = true;
      }
    } finally {
      yield* _magicLinkStream();
    }
  }

  Stream<String> _magicLinkStream() => _appLinkDataSource
      .listenForIncomingActions()
      .where((event) => _magicLinkParser.isValid(event))
      .map((event) => _magicLinkParser.parseMagicLink(event));
}
