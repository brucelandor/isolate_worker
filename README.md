# A simple IsolateWorker

## Usage

A simple usage example:

```dart
import 'package:isolate_worker/isolate_worker.dart';

void main() async {
  final w = IsolateWorker(toUpper);
  await w.ready;
  final result = await w.sendReceive("hello, world");
  print(result);
  w.kill();
}

dynamic toUpper(dynamic request) {
  final r = request as String;
  return r.toUpperCase();
}
```
