# A brainfuck IsolateWorker

## Usage

A simple usage example:

```dart
import 'dart:isolate';

import 'package:isolate_worker/isolate_worker.dart';

main() async {
  final w = IsolateWorker(toUppercase);
  await w.ready;
  final result = await w.sendReceive("hello, world");
  print(result);
  w.kill();
}

toUppercase(SendPort sendPort) {
  final rp = ReceivePort();
  sendPort.send(rp.sendPort);
  rp.listen((msg) async {
    final request = msg as Map<String, dynamic>;
    final data = request["requestData"] as String;
    final resultPort = request["sendPort"] as SendPort;
    resultPort.send(data.toUpperCase());
  });
}
```
