import 'package:counter/common/logger.dart';
import 'package:counter/core/counter_server_boot.dart';
import 'package:counter/models/count.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'api/api.dart' as api;
import 'views/counter_view.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initLogger();

  var port = await CounterServerBoot.instance.start();

  await init(port);
  var result = await api.getCounter();
  runApp(ChangeNotifierProvider(
    create: (context) => CountModel(result.count),
    child: const MyApp(),
  ));
}

Future<void> init(int port) async {
  api.init('', '', '', port: port);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const CounterView(title: 'Flutter Demo Home Page'),
    );
  }
}
