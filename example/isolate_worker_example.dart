import 'dart:isolate';

import 'package:isolate_worker/isolate_worker.dart';

void main() async {
  final w = IsolateWorker(toUpper);
  await w.ready;
  final result = await w.sendReceive("hello, world");
  print(result);
}

toUpper(SendPort sendPort) {
  final rp = ReceivePort();
  sendPort.send(rp.sendPort);
  rp.listen((data) {
    final request = data as Map<String, dynamic>;
    final requestData = request['requestData'] as String;
    final resultPort = request["sendPort"] as SendPort;
    resultPort.send(requestData.toUpperCase());
  });
}
