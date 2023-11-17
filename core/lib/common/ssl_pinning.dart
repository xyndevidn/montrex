// coverage:ignore-file

import 'dart:developer';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

class SslPinning {
  static Future<HttpClient> customHttpClient() async {
    SecurityContext context = SecurityContext(withTrustedRoots: false);
    try {
      final certBytes = await rootBundle.load('certificates/certificates.pem');
      context.setTrustedCertificatesBytes(certBytes.buffer.asInt8List());
      log('certificates added!');
    } on TlsException catch (e) {
      if (e.osError?.message != null &&
          e.osError!.message.contains('CERT_ALREADY_IN_HASH_TABLE')) {
        log('certificates already trusted! Skipping.');
      } else {
        log('certificates exception: $e');
        rethrow;
      }
    } catch (e) {
      log('Unexpected error $e');
      rethrow;
    }
    HttpClient httpClient = HttpClient(context: context);
    httpClient.badCertificateCallback =
        (X509Certificate cert, String host, int port) => false;

    return httpClient;
  }

  static Future<http.Client> createSslClient() async {
    IOClient client = IOClient(await SslPinning.customHttpClient());
    return client;
  }
}
