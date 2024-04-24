import 'dart:convert';
import 'dart:isolate';

import 'package:counter/core/ffi/http_server_bind.dart';
import 'package:counter/models/start_config.dart';
import 'package:ffi/ffi.dart';
import 'dart:ffi' as ffi;
import 'package:path/path.dart' as path;

Future<int> run() async {
  var libraryPath = path.join('include', 'http_server.dll');
  return await Isolate.run(() async {
    Future<int> f() => Isolate.run(() {
          var exe = HttpServerBind(ffi.DynamicLibrary.open(libraryPath));
          var result = exe.Start(
              jsonEncode(StartConfig(databaseUrl: "db.sqlite"))
                  .toNativeUtf8()
                  .cast());
          if (result.r1 != ffi.nullptr) {
            var err = result.r1.cast<Utf8>().toDartString();
            print(err);
            throw Exception("Error of Starting Server...");
          }
          final port = result.r0;
          return port;
        });
    return await f();
  });
}

void main() async {
  var i = await run();
  print(i);
}
