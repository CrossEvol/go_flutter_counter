import 'dart:io';
import 'dart:isolate';

import 'package:counter/core/common/counter_server_channel.dart';
import 'package:counter/core/common/counter_server_ffi.dart';
import 'package:counter/core/common/counter_server_interface.dart';

import '../counter_server_boot.dart';
import 'dart:ffi' as ffi;
import 'package:counter/core/ffi/http_server_bind.dart';

CounterServerBoot create() => CounterServerBootNative();

class CounterServerBootNative implements CounterServerBoot {
  late CounterServerInterface _counterServerInterface;

  @override
  Future<int> start() async {
    if (Platform.isWindows) {
      var libraryPath = 'http_server.dll';
      _counterServerInterface = CounterServerFFi(
          HttpServerBind(ffi.DynamicLibrary.open(libraryPath)));
    } else if (Platform.isAndroid) {
      _counterServerInterface = CounterServerChannel();
    }

    return await Isolate.run(() async {
      var port = _counterServerInterface.start();
      return port;
    });
  }

  @override
  Future<void> stop() async {
    return await _counterServerInterface.stop();
  }
}
