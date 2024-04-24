import 'counter_server_boot_stub.dart'
    if (dart.library.io) 'entry/counter_server_boot_native.dart';

abstract class CounterServerBoot {
  static CounterServerBoot? _instance;

  static CounterServerBoot get instance {
    _instance ??= CounterServerBoot();
    return _instance!;
  }

  factory CounterServerBoot() => create();

  Future<int> start();

  Future<void> stop();
}
