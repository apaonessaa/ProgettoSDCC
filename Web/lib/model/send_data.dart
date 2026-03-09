import 'dart:convert';
import 'dart:typed_data';
import 'dart:js_interop'; 
import 'package:mime/mime.dart';
import 'package:web/web.dart' show FormData, Blob, BlobPropertyBag; 
import 'package:fetch_api/fetch_api.dart';
import 'package:newsweb/model/entity/article.dart';
import 'package:newsweb/model/endpoints.dart';

class SendData {
  static SendData sharedInstance = SendData();

  String _getSubType(String filename) {
    final mimeType = lookupMimeType(filename);
    return mimeType?.split('/').last ?? 'unknown';
  }

  Future<void> save(Article art, Uint8List imageBytes, String imageFilename) async {
    final url = '${Endpoints.PROTECTED_API}${Endpoints.ARTICLE}';

    final formData = FormData();

    final articleJson = jsonEncode(art.toJson());
    final articleBlob = Blob([articleJson.toJS].toJS, BlobPropertyBag(type: 'application/json'));
    formData.append('article', articleBlob, 'article.json');

    final imageBlob = Blob([imageBytes.toJS].toJS, BlobPropertyBag(type: 'image/${_getSubType(imageFilename)}'));
    formData.append('image', imageBlob, imageFilename);

    try {
      final RequestInit requestOptions = RequestInit(
        method: 'POST',
        headers: null,
        body: RequestBody.fromFormData(formData),
        mode: RequestMode.cors,
        credentials: RequestCredentials.cors,
        cache: RequestCache.noCache,
        redirect: RequestRedirect.follow,
        referrer: "",
        referrerPolicy: RequestReferrerPolicy.noReferrer,
        integrity: "",
        keepalive: false,
        signal: null,
        duplex: null,
      );
      final response = await fetch(url, requestOptions);

      if (response.status == 201) {
        print("Articolo salvato con successo!");
      } else {
        print("Errore nel salvataggio: ${response.status}");
        throw Exception();
      }
    } catch (e) {
      print("Errore durante la richiesta fetch: $e");
      throw Exception();
    }
  }

  Future<void> update(Article art, Uint8List? imageBytes, String imageFilename) async {
    final url = '${Endpoints.PROTECTED_API}${Endpoints.article(art.title)}';
    final formData = FormData();

    final articleJson = jsonEncode(art.toJson());
    final articleBlob = Blob([articleJson.toJS].toJS, BlobPropertyBag(type: 'application/json'));
    formData.append('article', articleBlob, 'article.json');

    if (imageBytes != null && imageBytes.isNotEmpty) {
      final imageBlob = Blob([imageBytes.toJS].toJS, BlobPropertyBag(type: 'image/${_getSubType(imageFilename)}'));
      formData.append('image', imageBlob, imageFilename);
    }

    try {
      final RequestInit requestOptions = RequestInit(
        method: 'PUT',
        headers: null,
        body: RequestBody.fromFormData(formData),
        mode: RequestMode.cors,
        credentials: RequestCredentials.cors,
        cache: RequestCache.noCache,
        redirect: RequestRedirect.follow,
        referrer: "",
        referrerPolicy: RequestReferrerPolicy.noReferrer,
        integrity: "",
        keepalive: false,
        signal: null,
        duplex: null,
      );
      final response = await fetch(url, requestOptions);

      if (response.status == 200) {
        print("Articolo aggiornato con successo!");
      } else {
        print("Errore nell'aggiornamento: ${response.status}");
        throw Exception();
      }
    } catch (e) {
      print("Errore durante la richiesta fetch: $e");
      throw Exception();
    }
  }

  Future<void> delete(String title) async {
    try {
      final url = '${Endpoints.PROTECTED_API}${Endpoints.article(title)}';
      final RequestInit requestOptions = RequestInit(
        method: 'DELETE',
        headers: null,
        body: null,
        mode: RequestMode.cors,
        credentials: RequestCredentials.cors,
        cache: RequestCache.noCache,
        redirect: RequestRedirect.follow,
        referrer: "",
        referrerPolicy: RequestReferrerPolicy.noReferrer,
        integrity: "",
        keepalive: false,
        signal: null,
        duplex: null,
      );
      final response = await fetch(url, requestOptions);

      if (response.status == 200 || response.status == 204) {
        print("Articolo eliminato.");
      } else {
        throw Exception("Status code: ${response.status}");
      }
    } catch (error) {
      print("Errore con l'eliminazione dell'articolo $title: $error");
      throw Exception(error);
    }
  }
}