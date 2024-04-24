import 'dart:convert';
import 'dart:io';

import 'package:counter/core/common/counter_server_interface.dart';
import 'package:counter/models/start_config.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class CounterServerChannel implements CounterServerInterface {
  static const _channel = MethodChannel('crossevol.com/HttpServer');

  @override
  Future<int> start() async {
    var result = await _channel.invokeMethod('start',
        {'config': jsonEncode(StartConfig(databaseUrl: await dataSource()))});
    return result as int;
  }

  @override
  Future<void> stop() async {
    return await _channel.invokeMethod('stop');
  }

  Future<String> dataSource() async {
    return Platform.isAndroid
        ? path.join((await getApplicationDocumentsDirectory()).path, 'dev.db')
        : path.join((await getTemporaryDirectory()).path, 'dev.db');
  }
}

// public static native long start(String config) throws Exception;
// public static native void stop();
