import 'package:flutter/widgets.dart';

class Config {
  final String tenantId;
  final String clientId;
  final String scope;
  final String responseType;
  final String redirectUri;
  final String? clientSecret;
  final String? resource;
  final String contentType;
  String? authorizationUrl;
  String? tokenUrl;
  final String nonce;
  Rect? screenSize;
  String? userAgent;

  ///ResponseType to mobile usually is "code", and web usually is "id_token+token"
  Config(
      {required this.tenantId,
      required this.clientId,
      required this.scope,
      required this.redirectUri,
      required this.responseType,
      this.clientSecret,
      this.resource,
      this.contentType = "application/x-www-form-urlencoded",
      this.userAgent,
      this.nonce = "nonce_value"}) {
    this.authorizationUrl =
        "https://login.microsoftonline.com/$tenantId/oauth2/v2.0/authorize";
    this.tokenUrl =
        "https://login.microsoftonline.com/$tenantId/oauth2/v2.0/token";
  }
}
