import 'dart:convert';

import 'package:counter/models/start_config.dart';
import 'package:flutter_test/flutter_test.dart';

void main() async {
  test('StartConfig', () {
    var startConfig = StartConfig(databaseUrl: "dev.db");
    var cfgJson = jsonEncode(startConfig.toJson());
    expect(cfgJson, equals('{"database_url":"dev.db"}'));
  });
}
