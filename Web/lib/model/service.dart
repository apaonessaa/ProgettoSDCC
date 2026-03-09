import 'dart:convert';
import 'package:fetch_api/fetch_api.dart';

enum HttpMethod { POST, GET, PUT, DELETE }
enum TypeHeader { JSON, URL_ENCODED, IMAGE }

class Service {
  static Future<dynamic> request(
    HttpMethod method,
    String serverAddress,
    String servicePath, {
    TypeHeader? type,
    Map<String, String>? params,
    dynamic body,
    bool includeCredentials = false, 
  }) async {
    // 1. Gestione URI
    Uri uri = Uri.parse(serverAddress).resolve(servicePath);
    if (params != null && params.isNotEmpty) {
      uri = uri.replace(queryParameters: params);
    }

    // 2. Preparazione Headers (Usando l'oggetto Headers richiesto dalla lib)
    final headers = Headers();
    dynamic requestBody;

    if (type == null || type == TypeHeader.JSON) {
      headers.set('Content-Type', 'application/json; charset=utf-8');
      requestBody = body != null ? json.encode(body) : null;
    } else if (type == TypeHeader.URL_ENCODED) {
      headers.set('Content-Type', 'application/x-www-form-urlencoded');
      if (body is Map) {
        requestBody = body.entries
            .map((e) => "${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value.toString())}")
            .join("&");
      }
    } else if (type == TypeHeader.IMAGE) {
      headers.set('Accept', 'image/*');
    }

    try {
      // 3. Configurazione RequestInit usando i valori corretti degli Enum
      final requestOptions = RequestInit(
        method: method.name, 
        headers: headers,
        body: requestBody,
        mode: RequestMode.cors,
        credentials: includeCredentials ? RequestCredentials.cors : RequestCredentials.sameOrigin,
        cache: RequestCache.noCache,
        redirect: RequestRedirect.follow, 
        referrer: "", 
        referrerPolicy: RequestReferrerPolicy.noReferrer, 
        integrity: "", 
        keepalive: false, 
        signal: null, 
        duplex: null, 
      );

      final response = await fetch(uri.toString(), requestOptions);

      if (response.ok || response.status == 202 || response.status == 302 || response.status == 204) {
        
        if (type == TypeHeader.IMAGE) {
          final arrayBuffer = await response.arrayBuffer();
          return arrayBuffer.asUint8List();
        }

        final text = await response.text();
        return (text.isEmpty) ? null : jsonDecode(text);
      } else {
        throw Exception('Failed request with status code: ${response.status}');
      }
    } catch (e) {
      throw Exception('Fetch request error: $e');
    }
  }
}