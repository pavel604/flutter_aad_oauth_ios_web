import '../model/config.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class AuthorizationRequest {
  String? url;
  String? redirectUrl;
  late Map<String, String> parameters;
  Map<String, String>? headers;
  bool? fullScreen;
  bool? clearCookies;

  AuthorizationRequest(Config config,
      {bool fullScreen: true, bool clearCookies: false}) {
    this.url = config.authorizationUrl;
    this.redirectUrl = config.redirectUri;
    this.parameters = {
      "client_id": config.clientId,
      "response_type": config.responseType,
      "redirect_uri": config.redirectUri,
      "scope": config.scope
    };
    if (kIsWeb) {
      this.parameters.addAll({"nonce": config.nonce});
    }
    this.fullScreen = fullScreen;
    this.clearCookies = clearCookies;
  }
}
