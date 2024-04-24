# Errors

## golang deserialization failure

Only public field(starts with UpperCase letter) can be deserialization.

## Illegal argument in isolate message
```shell
D:/androidStudio/flutter/flutter_windows_3.16.9-stable/bin/cache/dart-sdk/bin/dart.exe --enable-asserts D:\GOLANG_CODE\go_flutter_count\ui\flutter\lib\verify_isolate.dart
Unhandled exception:
Invalid argument(s): Illegal argument in isolate message: (object is a DynamicLibrary)
 <- field this in DynamicLibrary.lookup (from dart:ffi)
 <- _lookup in Instance of 'HttpServerBind' (from package:counter/core/ffi/http_server_bind.dart)
 <- field exe in run.<anonymous closure> (from package:counter/verify_isolate.dart)
 <- resultPort in Instance of '_RemoteRunner<int>' (from dart:isolate)

#0      Isolate._spawnFunction (dart:isolate-patch/isolate_patch.dart:398:25)
#1      Isolate.spawn (dart:isolate-patch/isolate_patch.dart:378:7)
#2      Isolate.run (dart:isolate:285:15)
#3      run (package:counter/verify_isolate.dart:13:18)
#4      main (package:counter/verify_isolate.dart:28:17)
#5      _delayEntrypointInvocation.<anonymous closure> (dart:isolate-patch/isolate_patch.dart:297:19)
#6      _RawReceivePort._handleMessage (dart:isolate-patch/isolate_patch.dart:184:12)

Process finished with exit code 255
```
to solve the problem, can see the document of Isolate:
```dart
  /// ```dart import:convert import:io
  ///
  /// void serializeAndWrite(File f, Object o) async {
  ///   final openFile = await f.open(mode: FileMode.append);
  ///   Future writeNew() async {
  ///     // Will fail with:
  ///     // "Invalid argument(s): Illegal argument in isolate message"
  ///     // because `openFile` is captured.
  ///     final encoded = await Isolate.run(() => jsonEncode(o));
  ///     await openFile.writeString(encoded);
  ///     await openFile.flush();
  ///     await openFile.close();
  ///   }
  ///
  ///   if (await openFile.position() == 0) {
  ///     await writeNew();
  ///   }
  /// }
  /// ```
  ///
  /// In such cases, you can create a new function to call [Isolate.run] that
  /// takes all of the required state as arguments.
  ///
  /// ```dart import:convert import:io
  ///
  /// void serializeAndWrite(File f, Object o) async {
  ///   final openFile = await f.open(mode: FileMode.append);
  ///   Future writeNew() async {
  ///     Future<String> encode(o) => Isolate.run(() => jsonEncode(o));
  ///     final encoded = await encode(o);
  ///     await openFile.writeString(encoded);
  ///     await openFile.flush();
  ///     await openFile.close();
  ///   }
  ///
  ///   if (await openFile.position() == 0) {
  ///     await writeNew();
  ///   }
  /// }
  /// ```

```

