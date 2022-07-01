import 'dart:convert';
import 'dart:io';

import 'package:better_informed_mobile/data/auth/api/dto/linked_in_user.dt.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';

@injectable
class LinkedinUserDataSource {
  Future<LinkedinUserDTO> getUser(String accessToken) async {
    final url = Uri.parse('https://api.linkedin.com/v2/me');
    final response = await http.get(
      url,
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $accessToken',
      },
    );

    if (response.statusCode == HttpStatus.ok) {
      final decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
      return LinkedinUserDTO.fromJson(decodedResponse);
    }

    throw HttpException(
      'Querying linkedin user failed with code: ${response.statusCode} accessToken $accessToken',
      uri: url,
    );
  }
}
