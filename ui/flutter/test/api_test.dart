import 'package:test/test.dart';
import 'package:counter/api/api.dart';

void main() {
  late int baseCount;
  init('', '', '');

  test('/status API', () async {
    var result = await status();
    expect(result.status, equals('OK'));
  });

  test('/counter API', () async {
    var result = await getCounter();
    baseCount = result.count;
  });

  test('/counter/increment', () async {
    await incrementCounter();
    var result = await getCounter();
    expect(result.count - baseCount, equals(1));
  });

  test('/counter/decrement', () async {
    await decrementCounter();
    var result = await getCounter();
    expect(result.count, equals(baseCount));
  });

  test('/counter/reset', () async {
    await incrementCounter();
    await incrementCounter();
    await incrementCounter();
    await resetCounter();
    var result = await getCounter();
    expect(result.count, equals(0));
  });
}
