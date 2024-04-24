import 'package:counter/core/common/counter_server_interface.dart';
import 'package:flutter/services.dart';

class CounterServerChannel implements CounterServerInterface {
  static const _channel = MethodChannel('crossevol.com/http_server');

  @override
  Future<int> start() async {
    var result = await _channel.invokeMethod('start', {'k1': 'v1'});
    return result as int;
  }

  @override
  Future<void> stop() async {
    return await _channel.invokeMethod('stop');
  }
}
