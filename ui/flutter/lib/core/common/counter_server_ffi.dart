import 'dart:async';
import 'dart:ffi';

import 'package:ffi/ffi.dart';
import 'package:counter/core/common/counter_server_interface.dart';
import 'package:counter/core/ffi/http_server_bind.dart';

class CounterServerFFi implements CounterServerInterface {
  late final HttpServerBind _httpServerBind;

  CounterServerFFi(this._httpServerBind);

  @override
  Future<int> start() {
    var completer = Completer<int>();
    var result = _httpServerBind.StartDesktopServer();
    if (result.r1 != nullptr) {
      completer.completeError(Exception(result.r1.cast<Utf8>().toDartString()));
    } else {
      completer.complete(result.r0);
    }
    return completer.future;
  }

  @override
  Future<void> stop() {
    var completer = Completer<void>();
    _httpServerBind.StopDesktopServer();
    completer.complete();
    return completer.future;
  }
}
