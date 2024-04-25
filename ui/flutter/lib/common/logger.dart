import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

late Logger logger;

Future<void> initLogger() async {
  logger = Logger(
    filter: null, // Use the default LogFilter (-> only log in debug mode)
    printer: PrettyPrinter(), // Use the PrettyPrinter to format and print log
    output: kReleaseMode
        ? await fileOutput()
        : ConsoleOutput(), // Use the default LogOutput (-> send everything to console)
  );
}

Future<FileOutput> fileOutput() async {
  var logPath =
      path.join((await getTemporaryDirectory()).path, 'counter.error.log');
  var fileOutput = FileOutput(file: File(logPath));
  return fileOutput;
}
