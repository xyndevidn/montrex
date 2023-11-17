// coverage:ignore-file

import 'package:core/common/ssl_pinning.dart';
import 'package:http/http.dart' as http;

class HttpSslPinning {
  static Future<http.Client> get _instance async =>
      _clientInstance ??= await SslPinning.createSslClient();
  static http.Client? _clientInstance;
  static http.Client get client => _clientInstance ?? http.Client();

  static Future<void> init() async {
    _clientInstance = await _instance;
  }
}
