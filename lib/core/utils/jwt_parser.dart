import 'dart:convert';

Map<String, dynamic> parseJwt(String token) {
  final parts = token.split('.');
  if (parts.length != 3) {
    throw Exception('Token inválido');
  }

  final payload = base64Url.normalize(parts[1]);
  final payloadMap = json.decode(utf8.decode(base64Url.decode(payload)));

  if (payloadMap is! Map<String, dynamic>) {
    throw Exception('Payload no es un JSON válido');
  }

  return payloadMap;
}
