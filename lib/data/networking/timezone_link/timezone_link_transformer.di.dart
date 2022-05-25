import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:injectable/injectable.dart';

const timezoneHeaderKey = 'x-timezone';

/// Transforms request by adding [timezoneHeaderKey] to its headers
/// If header map does not exist it will create one
///
/// Header value is app name and app version separated by colon ':'
/// Example: {'x-timezone': '+00:00'}
@injectable
class TimezoneLinkTransformer {
  TimezoneLinkTransformer();

  Future<Request> call(Request request) async {
    final timezoneHeaderValue = await _createTimezoneHeaderValue();
    return _transformRequest(request, timezoneHeaderValue);
  }

  Future<String> _createTimezoneHeaderValue() async {
    return DateTime.now().timeZoneOffsetString;
  }

  Request _transformRequest(Request request, String timezoneHeaderValue) {
    return request.updateContextEntry<HttpLinkHeaders>(
      (entry) {
        final timezoneHeaderEntry = {
          timezoneHeaderKey: timezoneHeaderValue,
        };

        if (entry == null) {
          return HttpLinkHeaders(
            headers: timezoneHeaderEntry,
          );
        } else {
          entry.headers.addAll(timezoneHeaderEntry);
          return entry;
        }
      },
    );
  }
}

extension on DateTime {
  String get timeZoneOffsetString {
    final offset = timeZoneOffset;
    final hours = offset.inHours > 0 ? offset.inHours : 1; // For fixing divide by 0

    if (!offset.isNegative) {
      return "+${offset.inHours.toString().padLeft(2, '0')}:${(offset.inMinutes % (hours * 60)).toString().padLeft(2, '0')}";
    } else {
      return "-${(-offset.inHours).toString().padLeft(2, '0')}:${(offset.inMinutes % (hours * 60)).toString().padLeft(2, '0')}";
    }
  }
}
