import '../model/config.dart';
import '../model/token.dart';
import 'platforms/request_code_unsupported.dart'
    if (dart.library.io) 'platforms/request_code_ios.dart'
    if (dart.library.js) 'platforms/request_code_web.dart';

abstract class RequestCode {
  static Exception get ex =>
      Exception("Access denied or authentation canceled.");
  static RequestCode getInstance(Config cf) {
    return getRequestCode(cf);
  }

  Future<String?> requestCode();
  Future<Token> requestToken();
  Future<void> clearCookies();
}
