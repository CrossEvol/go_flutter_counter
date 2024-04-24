
abstract class CounterServerInterface {
  Future<int> start();

  Future<void> stop();
}
