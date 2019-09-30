import 'dart:isolate';

import 'package:isolate_worker/isolate_worker.dart';
import 'package:test/test.dart';

void main() {
  test("isolate worker", () async {
    final w = IsolateWorker(toUpper);
    await w.ready;
    final result = await w.sendReceive("hello, world");
    expect(result, "HELLO, WORLD");
  });
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
