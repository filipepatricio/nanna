import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:better_informed_mobile/data/auth/api/provider/linkedin/authorization_state_generator.di.dart';
import 'package:better_informed_mobile/data/auth/api/provider/linkedin/linkedin_user_data_source.di.dart';
import 'package:better_informed_mobile/data/auth/api/provider/oauth_credential_provider_data_source.di.dart';
import 'package:better_informed_mobile/data/auth/api/provider/provider_dto.dart';
import 'package:better_informed_mobile/data/user/api/dto/user_meta_dto.dt.dart';
import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:better_informed_mobile/domain/auth/data/exceptions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:injectable/injectable.dart';
import 'package:oauth2/oauth2.dart';

@injectable
class LinkedinCredentialDataSource implements OAuthCredentialProviderDataSource {
  LinkedinCredentialDataSource(
    this._linkedinUserDataSource,
    this._authorizationStateGenerator,
    this.appConfig,
  );

  final LinkedinUserDataSource _linkedinUserDataSource;
  final AuthorizationStateGenerator _authorizationStateGenerator;
  final AppConfig appConfig;

  @override
  Future<OAuthUserDTO> fetchOAuthUser() async {
    final authGrant = AuthorizationCodeGrant(
      appConfig.linkedinConfig.clientId,
      Uri.parse('https://www.linkedin.com/oauth/v2/authorization'),
      Uri.parse('https://www.linkedin.com/oauth/v2/accessToken'),
      secret: appConfig.linkedinConfig.clientSecret,
      basicAuth: false,
      // Funny thing, dart oauth2 library enforces PKCE flow on every provider
      // but linkedin allows PKCE flow only with https://www.linkedin.com/oauth/native-pkce/authorization url
      // which is restricted to their "Sales Navigator partners", so in order to not rewrite the whole library
      // and be able to login we are passing empty string for [codeVerifier] which is doing the job, at least for now
      codeVerifier: '',
    );

    final redirectUri = Uri.parse(appConfig.linkedinConfig.redirectUri);
    const scopes = [
      'r_emailaddress',
      'r_liteprofile',
    ];

    final state = _authorizationStateGenerator.generate();
    final authUri = authGrant.getAuthorizationUrl(redirectUri, scopes: scopes, state: state);
    final redirect = await _redirect(authUri);

    final accessToken = await _retrieveAccessToken(authGrant, redirect);
    final user = await _linkedinUserDataSource.getUser(accessToken);

    return OAuthUserDTO(
      user: UserMetaDTO(
        user.firstName,
        user.lastName,
      ),
      token: accessToken,
      provider: SignInProviderDTO.linkedin,
    );
  }

  Future<Uri> _redirect(Uri authUri) async {
    if (Platform.isAndroid) {
      try {
        final redirect = await FlutterWebAuth.authenticate(
          url: authUri.toString(),
          callbackUrlScheme: 'https',
        );
        return Uri.parse(redirect);
      } on PlatformException catch (exception) {
        if (exception.code == 'CANCELED') throw SignInAbortedException();
        rethrow;
      }
    } else {
      Uri? redirect;
      final compiler = Completer();

      final options = InAppBrowserClassOptions(
        crossPlatform: InAppBrowserOptions(hideUrlBar: true),
        inAppWebViewGroupOptions: InAppWebViewGroupOptions(crossPlatform: InAppWebViewOptions(clearCache: true)),
      );

      await CustomInAppBrowser(
        onRedirect: (url) {
          redirect = url;
          compiler.complete();
        },
        onUserExit: compiler.complete,
      ).openUrlRequest(
        urlRequest: URLRequest(url: authUri),
        options: options,
      );

      await compiler.future;

      if (redirect == null) throw SignInAbortedException();

      return redirect!;
    }
  }

  Future<String> _retrieveAccessToken(AuthorizationCodeGrant authGrant, Uri redirect) async {
    try {
      final authResult = await authGrant.handleAuthorizationResponse(
        redirect.queryParameters,
      );
      return authResult.credentials.accessToken;
    } on FormatException catch (exception) {
      final rawJson = exception.message.split('\n\n').last;

      try {
        final json = jsonDecode(rawJson);
        return json['access_token'] as String;
      } on FormatException catch (_) {
        // Rethrow original exception
        throw exception;
      }
    } on AuthorizationException catch (exception) {
      if (exception.error == 'user_cancelled_login') {
        throw SignInAbortedException();
      }
      rethrow;
    }
  }
}

class CustomInAppBrowser extends InAppBrowser {
  CustomInAppBrowser({
    required this.onRedirect,
    required this.onUserExit,
  });

  final void Function(Uri) onRedirect;
  final VoidCallback onUserExit;

  @override
  void onUpdateVisitedHistory(Uri? url, bool? androidIsReload) {
    if (url?.toString().contains('api/auth/callback/linkedin?code') ?? false) {
      onRedirect(url!);
      close();
    }
  }

  @override
  void onExit() => onUserExit();
}
