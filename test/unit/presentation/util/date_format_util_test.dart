import 'package:better_informed_mobile/presentation/util/date_format_util.dart';
import 'package:clock/clock.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('currentBriefDate', () {
    final briefDate = DateTime(2022, 05, 27);
    test(
      'returns Today for brief date that is same as DateTime.now()',
      () {
        final datesToCheck = [
          DateTime(2022, 05, 27, 00, 00),
          DateTime(2022, 05, 27, 12, 30),
          DateTime(2022, 05, 27, 23, 59),
        ];

        for (final date in datesToCheck) {
          withClock(Clock.fixed(date), () {
            final title = DateFormatUtil.currentBriefDate(briefDate);
            expect(title, 'Today');
          });
        }
      },
    );

    test(
      'returns Yesterday for brief date that is day before today',
      () {
        final datesToCheck = [
          DateTime(2022, 05, 28, 00, 00),
          DateTime(2022, 05, 28, 12, 30),
          DateTime(2022, 05, 28, 23, 59),
        ];

        for (final date in datesToCheck) {
          withClock(Clock.fixed(date), () {
            final title = DateFormatUtil.currentBriefDate(briefDate);
            expect(title, 'Yesterday');
          });
        }
      },
    );

    test(
      'returns [Week day name] for brief date that is not today nor yesterday',
      () {
        final datesToCheck = [
          DateTime(2022, 05, 29, 00, 00),
          DateTime(2022, 06, 13, 12, 30),
          DateTime(2022, 06, 29, 23, 59),
        ];

        for (final date in datesToCheck) {
          withClock(Clock.fixed(date), () {
            final title = DateFormatUtil.currentBriefDate(briefDate);
            expect(title, 'Friday 27th');
          });
        }
      },
    );
  });
}
