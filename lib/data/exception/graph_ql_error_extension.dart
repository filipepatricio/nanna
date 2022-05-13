import 'package:graphql_flutter/graphql_flutter.dart';

extension GraphQLErrorExtension on GraphQLError {
  String? get code {
    final code = extensions?['code'];
    if (code is String) return code;
    return null;
  }
}
