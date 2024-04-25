
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../api/api.dart' as api;

import '../models/count.dart';

class CounterView extends StatefulWidget {
  const CounterView({super.key, required this.title});

  final String title;

  @override
  State<CounterView> createState() => _CounterViewState();
}

class _CounterViewState extends State<CounterView> {
  late Future<String> _fetchStatus;

  @override
  void initState() {
    super.initState();
    _fetchStatus = fetchStatus();
  }

  @override
  Widget build(BuildContext context) {
    final ButtonStyle outlineButtonStyle = OutlinedButton.styleFrom(
      backgroundColor: Colors.blue[200],
      foregroundColor: Colors.black87,
      minimumSize: const Size(88, 36),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
    ).copyWith(
      side: MaterialStateProperty.resolveWith<BorderSide?>(
            (Set<MaterialState> states) {
          if (states.contains(MaterialState.pressed)) {
            return BorderSide(
              color: Theme.of(context).colorScheme.secondary,
              width: 1,
            );
          }
          return null;
        },
      ),
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Consumer<CountModel>(
              // future: _fetchCount,
                builder: (context, cm, child) {
                  return Text(
                    '${cm.count}',
                    style: Theme.of(context).textTheme.headlineMedium,
                  );
                }),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Consumer<CountModel>(builder: (ctx, cm, child) {
                  return OutlinedButton(
                      onPressed: () async {
                        await api.incrementCounter();
                        var result = await api.getCounter();
                        cm.count = result.count;
                      },
                      child: const Icon(Icons.add));
                }),
                const SizedBox(
                  width: 20,
                ),
                Consumer<CountModel>(builder: (ctx, cm, child) {
                  return OutlinedButton(
                      onPressed: () async {
                        await api.decrementCounter();
                        var result = await api.getCounter();
                        cm.count = result.count;
                      },
                      child: const Icon(Icons.remove));
                }),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Consumer<CountModel>(builder: (ctx, cm, child) {
              return OutlinedButton(
                style: outlineButtonStyle,
                onPressed: () async {
                  await api.resetCounter();
                  var result = await api.getCounter();
                  cm.count = result.count;
                },
                child: const Text('Reset Count'),
              );
            })
          ],
        ),
      ),
      floatingActionButton: FutureBuilder<String>(
        future: _fetchStatus,
        builder: (context, snapshot) {
          return FloatingActionButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  action: SnackBarAction(
                    label: 'Close',
                    onPressed: () {
                      // Code to execute.
                    },
                  ),
                  content: snapshot.error == null
                      ? Text('Status is ${snapshot.data!}')
                      : const Text('Server has not been ready...'),
                  // content: const Text('Status is OK'),
                  duration: const Duration(milliseconds: 1500),
                  width: 280.0,
                  // Width of the SnackBar.
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0, // Inner padding for SnackBar content.
                  ),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              );
            },
            tooltip: 'Status???',
            child: const Icon(Icons.signal_wifi_statusbar_4_bar),
          );
        },
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Future<int> fetchCountValue() async {
    var result = await api.getCounter();
    return result.count;
  }

  Future<String> fetchStatus() async {
    var result = await api.status();
    return result.status;
  }
}
