import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/widget/snackbar/snackbar_message.dt.dart';
import 'package:better_informed_mobile/presentation/widget/snackbar/snackbar_view.dart';
import 'package:flutter/material.dart';

import '../visual_test_utils.dart';

void main() {
  visualTest(
    SnackbarView,
    (tester) async {
      final snackbarSuccess = SnackbarView(
        message: SnackbarMessage.simple(
          message: 'This is an success snackbar',
          type: SnackbarMessageType.success,
        ),
      );
      final snackbarInfo = SnackbarView(
        message: SnackbarMessage.simple(
          message: 'This is an info snackbar',
          type: SnackbarMessageType.info,
        ),
      );
      final snackbarWarning = SnackbarView(
        message: SnackbarMessage.simple(
          message: 'This is an warning snackbar',
          type: SnackbarMessageType.warning,
        ),
      );
      final snackbarError = SnackbarView(
        message: SnackbarMessage.simple(
          message: 'This is an error snackbar',
          type: SnackbarMessageType.error,
        ),
      );
      final snackbarSubscription = SnackbarView(
        message: SnackbarMessage.simple(
          message: 'This is an subscription snackbar',
          type: SnackbarMessageType.subscription,
        ),
      );
      final snackbarSuccessSub = SnackbarView(
        message: SnackbarMessage.simple(
          message: 'This is an success snackbar',
          subMessage: 'This is the sub message',
          type: SnackbarMessageType.success,
        ),
      );
      final snackbarInfoSub = SnackbarView(
        message: SnackbarMessage.simple(
          message: 'This is an info snackbar',
          subMessage: 'This is the sub message',
          type: SnackbarMessageType.info,
        ),
      );
      final snackbarWarningSub = SnackbarView(
        message: SnackbarMessage.simple(
          message: 'This is an warning snackbar',
          subMessage: 'This is the sub message',
          type: SnackbarMessageType.warning,
        ),
      );
      final snackbarErrorSub = SnackbarView(
        message: SnackbarMessage.simple(
          message: 'This is an error snackbar',
          subMessage: 'This is the sub message',
          type: SnackbarMessageType.error,
        ),
      );
      final snackbarSubscriptionSub = SnackbarView(
        message: SnackbarMessage.simple(
          message: 'This is an subscription snackbar',
          subMessage: 'This is the sub message',
          type: SnackbarMessageType.subscription,
        ),
      );

      final action = SnackbarAction(label: 'Action', callback: () {});

      final snackbarSuccessAction = SnackbarView(
        message: SnackbarMessage.simple(
          message: 'This is an success snackbar',
          type: SnackbarMessageType.success,
          action: action,
        ),
      );
      final snackbarInfoAction = SnackbarView(
        message: SnackbarMessage.simple(
          message: 'This is an info snackbar',
          type: SnackbarMessageType.info,
          action: action,
        ),
      );
      final snackbarWarningAction = SnackbarView(
        message: SnackbarMessage.simple(
          message: 'This is an warning snackbar',
          type: SnackbarMessageType.warning,
          action: action,
        ),
      );
      final snackbarErrorAction = SnackbarView(
        message: SnackbarMessage.simple(
          message: 'This is an error snackbar',
          type: SnackbarMessageType.error,
          action: action,
        ),
      );
      final snackbarSubscriptionAction = SnackbarView(
        message: SnackbarMessage.simple(
          message: 'This is an subscription snackbar',
          type: SnackbarMessageType.subscription,
          action: action,
        ),
      );
      final snackbarSuccessSubAction = SnackbarView(
        message: SnackbarMessage.simple(
          message: 'This is an success snackbar',
          subMessage: 'This is the sub message',
          type: SnackbarMessageType.success,
          action: action,
        ),
      );
      final snackbarInfoSubAction = SnackbarView(
        message: SnackbarMessage.simple(
          message: 'This is an info snackbar',
          subMessage: 'This is the sub message',
          type: SnackbarMessageType.info,
          action: action,
        ),
      );
      final snackbarWarningSubAction = SnackbarView(
        message: SnackbarMessage.simple(
          message: 'This is an warning snackbar',
          subMessage: 'This is the sub message',
          type: SnackbarMessageType.warning,
          action: action,
        ),
      );
      final snackbarErrorSubAction = SnackbarView(
        message: SnackbarMessage.simple(
          message: 'This is an error snackbar',
          subMessage: 'This is the sub message',
          type: SnackbarMessageType.error,
          action: action,
        ),
      );
      final snackbarSubscriptionSubAction = SnackbarView(
        message: SnackbarMessage.simple(
          message: 'This is an subscription snackbar',
          subMessage: 'This is the sub message',
          type: SnackbarMessageType.subscription,
          action: action,
        ),
      );

      await tester.startApp(
        initialRoute: PlaceholderPageRoute(
          child: Material(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(
                  AppDimens.m,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ...[
                      snackbarSuccess,
                      snackbarInfo,
                      snackbarWarning,
                      snackbarError,
                      snackbarSubscription,
                      snackbarSuccessSub,
                      snackbarInfoSub,
                      snackbarWarningSub,
                      snackbarErrorSub,
                      snackbarSubscriptionSub,
                      snackbarSuccessAction,
                      snackbarInfoAction,
                      snackbarWarningAction,
                      snackbarErrorAction,
                      snackbarSubscriptionAction,
                      snackbarSuccessSubAction,
                      snackbarInfoSubAction,
                      snackbarWarningSubAction,
                      snackbarErrorSubAction,
                      snackbarSubscriptionSubAction,
                    ].expand((item) => [item, const SizedBox(height: AppDimens.m)])
                  ],
                ),
              ),
            ),
          ),
        ),
      );
      await tester.matchGoldenFile();
    },
    testConfig: TestConfig.autoHeight(),
  );
}
