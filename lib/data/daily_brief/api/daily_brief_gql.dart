import 'package:better_informed_mobile/data/gql/common_gql.dart';
import 'package:gql/ast.dart' show DocumentNode;
import 'package:graphql_flutter/graphql_flutter.dart';

class DailyBriefGql {
  static DocumentNode currentBrief() => gql('''
    query currentBriefForStartupScreen {
      currentBrief {
        $_greeting
        $_goodbye
        numberOfTopics
        topics {
          ${CommonGQLModels.topic}
        }
      }
    }
  ''');

  static const String _greeting = '''
    greeting {
      headline
      message
      icon
    }
  ''';

  static const String _goodbye = '''
    goodbye {
      headline
      message
      icon
    }
  ''';
}
