import 'dart:async';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import '../../request_code/request_code.dart';
import '../../model/config.dart';
import '../../model/token.dart';
import '../../request/authorization_request.dart';

RequestCode getRequestCode(cf) => RequestCodeIos(cf);

class RequestCodeIos extends RequestCode {
  final StreamController<String?> _onCodeListener = new StreamController();
  final FlutterWebviewPlugin _webView = FlutterWebviewPlugin();
  final Config _config;
  late AuthorizationRequest _authorizationRequest;

  var _onCodeStream;

  RequestCodeIos(Config config) : _config = config {
    _authorizationRequest = AuthorizationRequest(config);
    _onCodeStream = _onCodeListener.stream.asBroadcastStream();
  }

  Future<String?> requestCode() async {
    var code;
    final String urlParams = _constructUrlParams();
    String initialURL =
        ("${_authorizationRequest.url}?$urlParams").replaceAll(" ", "%20");

    await _webView.launch(
      initialURL,
      clearCookies: _authorizationRequest.clearCookies!,
      hidden: false,
      rect: _config.screenSize,
      userAgent: _config.userAgent,
    );

    _webView.onUrlChanged.listen((String url) {
      var uri = Uri.parse(url);

      if (uri.queryParameters['error'] != null) {
        _webView.close();
        _onCodeListener.add(null);
      }

      if (uri.queryParameters['code'] != null) {
        _webView.close();
        _onCodeListener.add(uri.queryParameters['code']);
      }
    });

    code = await _onCode.first;
    return code;
  }

  Future<void> clearCookies() async {
    await _webView.launch('', hidden: true);
    await _webView.cleanCookies();
    await _webView.clearCache();
    await _webView.close();
  }

  Stream<String?> get _onCode =>
      _onCodeStream ??= _onCodeListener.stream.asBroadcastStream();

  String _constructUrlParams() =>
      _mapToQueryParams(_authorizationRequest.parameters);

  String _mapToQueryParams(Map<String, String> params) {
    final queryParams = <String>[];
    params
        .forEach((String key, String value) => queryParams.add("$key=$value"));
    return queryParams.join("&");
  }

  Future<Token> requestToken() {
    throw Exception("Unimplemented Error");
  }
}
