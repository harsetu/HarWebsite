import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class CustomCacheManager {
  static final CustomCacheManager _instance = CustomCacheManager._internal();
  late CacheManager _cacheManager;

  factory CustomCacheManager() {
    return _instance;
  }

  CustomCacheManager._internal() {
    _cacheManager = CacheManager(
      Config(
        'customCacheKey',
        stalePeriod: const Duration(minutes: 15),
        maxNrOfCacheObjects: 100,
      ),
    );
  }

  Future<dynamic> get(String url) async {
    final fileInfo = await _cacheManager.getFileFromCache(url);
    if (fileInfo != null && fileInfo.validTill.isAfter(DateTime.now()) == true) {
      // return cached data if not expired
      // return jsonDecode(await fileInfo.file.readAsString());
      // return cached data if not expired
      final cachedDataBytes = await fileInfo.file.readAsBytes();
      final cachedDataJson = utf8.decode(cachedDataBytes);
      final cachedData = jsonDecode(cachedDataJson);
      return cachedData;
    } else {
      // make a new request and cache the response
      return null;
    }
  }

  Future<void> put(String url, dynamic data, {String? eTag}) async {
    await _cacheManager.putFile(
      url,
      data,
      eTag: eTag,
    );
    await _storeETagInCache(url, eTag);
  }

  Future<void> _storeETagInCache(String url, String? eTag) async {
    final cacheInfo = await _cacheManager.getFileFromCache(url);
    if (cacheInfo != null) {
      final file = cacheInfo.file;
      final currentBytes = await file.readAsBytes();
      final jsonData = jsonDecode(utf8.decode(currentBytes)) as Map<String, dynamic>;
      jsonData['eTag'] = eTag;
      final updatedBytes = utf8.encode(jsonEncode(jsonData));
      await file.writeAsBytes(updatedBytes);
    }
  }

  Future<String?> getETagFromCache(String url) async {
    final cacheInfo = await _cacheManager.getFileFromCache(url);
    if (cacheInfo != null) {
      final fileContents = await cacheInfo.file.readAsBytes();
      final jsonData = jsonDecode(utf8.decode(fileContents)) as Map<String, dynamic>;
      return jsonData['eTag'] as String?;
    }
    return null;
  }
}

class CacheResponse {
  final Uint8List data;
  final String? eTag;

  CacheResponse(this.data, this.eTag);
}
