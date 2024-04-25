import 'dart:io';
import 'dart:isolate';

import 'package:counter/common/logger.dart';
import 'package:counter/core/common/counter_server_channel.dart';
import 'package:counter/core/common/counter_server_ffi.dart';
import 'package:counter/core/common/counter_server_interface.dart';

import '../counter_server_boot.dart';
import 'dart:ffi' as ffi;
import 'package:counter/core/ffi/http_server_bind.dart';

CounterServerBoot create() => CounterServerBootNative();

class CounterServerBootNative implements CounterServerBoot {
  late CounterServerInterface _counterServer;

  @override
  Future<int> start() async {
    try {
      if (Platform.isWindows) {
        return await Isolate.run(() async {
          var libraryPath = 'http_server.dll';
          _counterServer = CounterServerFFi(
              HttpServerBind(ffi.DynamicLibrary.open(libraryPath)));
          return await _counterServer.start();
        });
      } else if (Platform.isAndroid) {
        _counterServer = CounterServerChannel();
        return await _counterServer.start();
      }
    } catch (e) {
      logger.e(e);
    }
    return 0;
  }

  @override
  Future<void> stop() async {
    return await _counterServer.stop();
  }
}
