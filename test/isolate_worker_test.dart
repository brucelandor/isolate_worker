import 'package:isolate_worker/isolate_worker.dart';
import 'package:test/test.dart';

void main() {
  test("single IsolateWorker", () async {
    final w = IsolateWorker(toUpper);
    await w.ready;
    final result = await w.sendReceive("hello, world");
    expect(result, "HELLO, WORLD");
    w.kill();
  });
  test("multiple IsolateWorkers", () async {
    final w1 = IsolateWorker(toUpper);
    await w1.ready;
    final w2 = IsolateWorker(toLower);
    await w2.ready;
    final r1 = await w1.sendReceive("hello");
    expect(r1, "HELLO");
    final r2 = await w2.sendReceive("HELLO");
    expect(r2, "hello");
    w1.kill();
    w2.kill();
  });
}

dynamic toUpper(dynamic request) {
  final r = request as String;
  return r.toUpperCase();
}

dynamic toLower(dynamic request) {
  final r = request as String;
  return r.toLowerCase();
}
