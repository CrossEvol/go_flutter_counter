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

## Database closed error

```shell
Apr 24 20:38:58.257 INF GET /counter 127.0.0.1:14778
Apr 24 20:38:58.277 ERR sql: database is closed request.method=GET request.url=/counter trace="goroutine 36 [running]:\nruntime/debug.Stack()
```

## Can see log in the console

```shell
Apr 24 20:40:17.267 INF GET /counter 127.0.0.1:45607
Apr 24 20:40:17.962 INF GET /status 127.0.0.1:45607
Apr 24 20:40:20.483 INF PUT /counter/increment 127.0.0.1:45607
```

is it related to the log/slog or other?

```golang
import (
	"log"
	"log/slog"
	"github.com/lmittmann/tint"
)

type application struct {
	logger  *slog.Logger
}

func (app *application) logRequestInfo(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		// Log request details
		app.logger.Info(fmt.Sprintf("%s %s %s", colorized(r.Method), r.URL.Path, r.RemoteAddr))

		// Call the next handler in the chain
		next.ServeHTTP(w, r)
	})
}
```

## can run in debug, can not run after build

may be should use foreground_task?

after run counterChannel code in Isolate

```dart
      } else
if (Platform.isAndroid) {
return await Isolate.run(() async {
_counterServer = CounterServerChannel();
return _counterServer.start();
});
```

it reports

```shell
Syncing files to device 22041211AC...
I/flutter (29110): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29110): │ #0   CounterServerBootNative.start (package:counter/core/entry/counter_server_boot_native.dart:35:14)
I/flutter (29110): │ #1   <asynchronous suspension>
I/flutter (29110): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (29110): │ ⛔ Bad state: The BackgroundIsolateBinaryMessenger.instance value is invalid until BackgroundIsolateBinaryMessenger.ensureInitialized is executed.
I/flutter (29110): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
E/flutter (29110): [ERROR:flutter/runtime/dart_vm_initializer.cc(41)] Unhandled Exception: Exception
E/flutter (29110): #0      _parse (package:counter/api/api.dart:66:5)
E/flutter (29110): <asynchronous suspension>
E/flutter (29110): #1      main (package:counter/main.dart:17:16)
E/flutter (29110): <asynchronous suspension>
E/flutter (29110): 
I/ossevol.counte(29110): Compiler allocated 4436KB to compile void android.view.ViewRootImpl.performTraversals()

```

compare the debug.apk & release.apk in the mobile

```text
拥有完全的网络访问权限
允许该应用创建网络套接字和使用自定义网络协议。浏览器和其他某些应用提供了向互联网发送数据的途径，因此应用无需该权限即可向互联网发送数据。
```

the debug.apk has this permission and the release.apk did not has.

`android/app/src/debug/AndroidManifest.xml`

```xml

<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <!-- The INTERNET permission is required for development. Specifically,
         the Flutter tool needs it to communicate with the running application
         to allow setting breakpoints, to provide hot reload, etc.
    -->
    <uses-permission android:name="android.permission.INTERNET" />
</manifest>
```

add `<uses-permission android:name="android.permission.INTERNET"/>`
to `android/app/src/main/AndroidManifest.xml`