import 'dart:io';

import 'package:dio/dio.dart';

import 'model.dart';

class _Client {
  static _Client? _instance;

  late Dio dio;

  _Client._internal();

  factory _Client(String network, String address, String apiToken) {
    if (_instance == null) {
      _instance = _Client._internal();
      var dio = Dio();
      var baseUrl = 'http://127.0.0.1:4444';
      dio.options.baseUrl = baseUrl;
      dio.options.contentType = Headers.jsonContentType;
      dio.options.sendTimeout = const Duration(seconds: 5);
      dio.options.connectTimeout = const Duration(seconds: 5);
      dio.options.receiveTimeout = const Duration(seconds: 60);
      dio.interceptors.add(InterceptorsWrapper(onRequest: (options, handler) {
        if (apiToken.isNotEmpty) {
          options.headers['X-Api-Token'] = apiToken;
        }
        handler.next(options);
      }));

      _instance!.dio = dio;
    }
    return _instance!;
  }
}

class TimeoutException implements Exception {
  final String message;

  TimeoutException(this.message);
}

late _Client _client;

void init(String network, String address, String apiToken) {
  _client = _Client(network, address, apiToken);
}

Future<T> _parse<T>(
  Future<Response> Function() fetch,
  T Function(dynamic json)? fromJsonT,
) async {
  try {
    var resp = await fetch();
    fromJsonT ??= (json) => null as T;
    if (resp.statusCode == 200) {
      return fromJsonT(resp.data);
    } else {
      throw Exception();
    }
  } on DioException catch (e) {
    if (e.type == DioExceptionType.sendTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.connectionTimeout) {
      throw TimeoutException("request timeout");
    }
    throw Exception();
  }
}

Future<GetStatusResult> status() async {
  return _parse<GetStatusResult>(() => _client.dio.get('/status'),
      (data) => GetStatusResult.fromJson(data));
}

Future<GetCounterResult> getCounter() async {
  return _parse<GetCounterResult>(() => _client.dio.get('/counter'),
      (data) => GetCounterResult.fromJson(data));
}

Future<void> incrementCounter() async {
  return _parse<void>(() => _client.dio.put('/counter/increment'), null);
}

Future<void> decrementCounter() async {
  return _parse<void>(() => _client.dio.put('/counter/decrement'), null);
}

Future<void> resetCounter() async {
  return _parse<void>(() => _client.dio.delete('/counter/reset'), null);
}
