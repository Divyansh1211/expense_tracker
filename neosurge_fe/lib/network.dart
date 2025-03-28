import 'dart:convert';
import 'dart:developer';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neosurge_fe/provider.dart';
import 'package:http/http.dart' as http;

////Watch networkrepoprovider to make sure you have the latest authtoken passed
///
final networkRepoProvider = StateProvider((ref) {
  final authToken = ref.watch(authTokenProvider);
  return NetworkRepo(authToken: authToken);
});

/// Contains common methods required for client side NetworkRepos [GET, POST, PUT, DELETE].
/// Pass the [url] from endpoints using [Endpoints] class.
/// Every method has an optional parameter [requireAuth] default [true].
/// Set [requireAuth] to [false] if [authToken] is Empty.

class NetworkRepo {
  final String? _authToken;

  NetworkRepo({
    required String? authToken,
  }) : _authToken = authToken;

  ////get request
  Future<Map<String, dynamic>> getRequest(
      {required String url, bool requireAuth = true}) async {
    final Map<String, String> requestHeaders = {
      "Content-Type": "application/json",
      "Authorization": "$_authToken"
    };
    if (requireAuth) {
      if ((_authToken ?? '').isEmpty) {
        return {'Error': 'Auth token is empty'};
      }
    }
    try {
      log('REQUEST TO : $url', name: "HTTP GET");
      log('requireAuth: $requireAuth', name: "HTTP GET");

      final response = await http.get(Uri.parse(url), headers: requestHeaders);
      log('RESPONSE : ${response.body}', name: "HTTP GET");
      return jsonDecode(response.body);
    } catch (e) {
      return {'error': e.toString()};
    }
  }

////post request
  Future<Map<String, dynamic>> postRequest({
    required String url,
    bool requireAuth = true,
    dynamic body,
  }) async {
    final Map<String, String> requestHeaders = {
      "Content-Type": "application/json",
      "Authorization": "$_authToken"
    };
    if (requireAuth) {
      if ((_authToken ?? '').isEmpty) {
        log('Auth token is empty', name: "HTTP POST");
        return {
          'error': 'Auth token is empty',
        };
      }
    }
    try {
      log('REQUEST TO : $url', name: "HTTP POST");
      log('requireAuth: $requireAuth', name: "HTTP POST");
      log('BODY : $body', name: "HTTP POST");

      final response = await http.post(Uri.parse(url),
          headers: requestHeaders, body: jsonEncode(body));
      log('RESPONSE : ${response.body}', name: "HTTP POST");
      return jsonDecode(response.body);
    } catch (e) {
      log(e.toString(), name: "HTTP POST");
      return {'error': e.toString()};
    }
  }

  /////delete request
  Future<String> deleteRequest(
      {required String url, dynamic body, bool requireAuth = true}) async {
    final Map<String, String> requestHeaders = {
      "Content-Type": "application/json",
      "Authorization": "$_authToken"
    };
    if (requireAuth) {
      if ((_authToken ?? '').isEmpty) {
        return "Auth token is empty";
      }
    }

    log('REQUEST TO : $url', name: "HTTP Delete");
    log('requireAuth : $requireAuth', name: "HTTP Delete");
    log('BODY : $body', name: "HTTP Delete");

    try {
      final response = await http.delete(Uri.parse(url),
          body: body != null ? jsonEncode(body) : null,
          headers: requestHeaders);
      log('RESPONSE : ${response.body}', name: "HTTP Delete");
      return response.body;
    } catch (e) {
      return e.toString();
    }
  }
}
