import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:better_informed_mobile/data/auth/api/provider/linkedin/linkedin_user_data_source.di.dart';
import 'package:better_informed_mobile/data/auth/api/provider/oauth_credential_provider_data_source.di.dart';
import 'package:better_informed_mobile/data/auth/api/provider/provider_dto.dart';
import 'package:better_informed_mobile/data/user/api/dto/user_meta_dto.dt.dart';
import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:better_informed_mobile/domain/auth/data/exceptions.dart';
import 'package:flutter/services.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:injectable/injectable.dart';
import 'package:oauth2/oauth2.dart';
import 'package:rxdart/rxdart.dart';
import 'package:uni_links/uni_links.dart';
import 'package:url_launcher/url_launcher.dart';

@injectable
class LinkedinCredentialDataSource implements OAuthCredentialProviderDataSource {
  LinkedinCredentialDataSource(
    this._linkedinUserDataSource,
    this.appConfig,
  );

  final LinkedinUserDataSource _linkedinUserDataSource;
  final AppConfig appConfig;

  @override
  Future<OAuthUserDTO> fetchOAuthUser() async {
    final authGrant = AuthorizationCodeGrant(
      appConfig.linkedinConfig.clientId,
      Uri.parse('https://www.linkedin.com/oauth/v2/authorization'),
      Uri.parse('https://www.linkedin.com/oauth/v2/accessToken'),
      secret: appConfig.linkedinConfig.clientSecret,
      basicAuth: false,
    );

    final redirectUri = Uri.parse(appConfig.linkedinConfig.redirectUri);
    const scopes = [
      'r_emailaddress',
      'r_liteprofile',
    ];

    final authUri = authGrant.getAuthorizationUrl(redirectUri, scopes: scopes);
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
      final openedWithSuccess = await launchUrl(authUri);

      if (!openedWithSuccess) throw Exception('LinkedIn authorization uri failed to open');

      final redirect = await uriLinkStream.whereType<Uri>().first;
      await closeInAppWebView();

      return redirect;
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
      final json = jsonDecode(rawJson);
      return json['access_token'] as String;
    } on AuthorizationException catch (exception) {
      if (exception.error == 'user_cancelled_login') {
        throw SignInAbortedException();
      }
      rethrow;
    }
  }
}
