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

dynamic toUpper(dynamic request) {
  final r = request as String;
  return r.toUpperCase();
}
