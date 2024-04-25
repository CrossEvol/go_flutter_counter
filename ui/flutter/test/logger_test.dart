import 'package:counter/common/logger.dart';
import 'package:flutter_test/flutter_test.dart';

void main() async {
  test('logger test', () async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await initLogger();
    logger.d('hello');
  });
}
