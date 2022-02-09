import 'dart:async';
import '../../request_code/request_code.dart';
import '../../model/config.dart';
import 'dart:html' as html;
import '../../model/token.dart';
import '../../request/authorization_request.dart';

RequestCode getRequestCode(cf) => RequestCodeWeb(cf);

class RequestCodeWeb extends RequestCode {
  final StreamController<Map<String, String>> _onCodeListener =
      new StreamController();
  final Config _config;
  late AuthorizationRequest _authorizationRequest;
  html.WindowBase? _popupWin;

  var _onCodeStream;

  RequestCodeWeb(Config config) : _config = config {
    _authorizationRequest = AuthorizationRequest(config);
  }

  Future<Token> requestToken() async {
    late Token token;
    final String urlParams = _constructUrlParams();

    String initialURL =
        ("${_authorizationRequest.url}?$urlParams").replaceAll(" ", "%20");
    try {
      _webAuth(initialURL);
    } on Exception catch (e) {
      return Future.error(e);
    }

    var jsonToken = await _onCode.first;
    token = Token.fromJson(jsonToken);
    return token;
  }

  _webAuth(String initialURL) {
    html.window.onMessage.listen((event) {
      var tokenParm = 'access_token';
      if (event.data.toString().contains(tokenParm)) {
        _geturlData(event.data.toString());
      }
      if (event.data.toString().contains("error")) {
        _closeWebWindow();
        throw Exception("Access denied or authentation canceled.");
      }
    });
    _popupWin = html.window.open(
        initialURL, "Microsoft Auth", "width=600,height=600,top=100,left=100");
  }

  _geturlData(String _url) {
    var url = _url.replaceFirst('#', "?");
    Uri uri = Uri.parse(url);

    if (uri.queryParameters["error"] != null) {
      _closeWebWindow();
      _onCodeListener
          .addError(Exception("Access denied or authentation canceled."));
    }

    var token = uri.queryParameters;
    _onCodeListener.add(token);

    _closeWebWindow();
  }

  _closeWebWindow() {
    if (_popupWin != null) {
      _popupWin?.close();
      _popupWin = null;
    }
  }

  Future<void> clearCookies() async {
    //CookieManager().clearCookies();
  }

  Stream<Map<String, String>> get _onCode =>
      _onCodeStream ??= _onCodeListener.stream.asBroadcastStream();

  String _constructUrlParams() =>
      _mapToQueryParams(_authorizationRequest.parameters);

  String _mapToQueryParams(Map<String, String> params) {
    final queryParams = <String>[];
    params
        .forEach((String key, String value) => queryParams.add("$key=$value"));
    return queryParams.join("&");
  }

  Future<String?> requestCode() {
    throw Exception("Unimplemented Error");
  }
}
