import 'dart:async';
import 'dart:isolate';

typedef MessageHandler = FutureOr<dynamic> Function(dynamic);

class IsolateWorker {
  static _isolateEntry(List args) {
    SendPort sendPort = args[0] as SendPort;
    MessageHandler handler = args[1] as MessageHandler;
    final rp = ReceivePort();
    sendPort.send(rp.sendPort);
    rp.listen((data) {
      final request = data as Map<String, dynamic>;
      final resultPort = request["sendPort"] as SendPort;
      final requestData = request["requestData"];
      final result = handler(requestData);
      resultPort.send(result);
    });
  }

  Completer<bool> _completer;
  Isolate _isolate;
  SendPort _sendPort;

  IsolateWorker(MessageHandler messageHandler)
      : _completer = Completer<bool>() {
    _init(messageHandler);
  }

  void _init(MessageHandler messageHandler) async {
    try {
      final rp = ReceivePort();
      _isolate =
          await Isolate.spawn(_isolateEntry, [rp.sendPort, messageHandler]);
      _sendPort = await rp.first;
      _completer.complete(true);
    } catch (e) {
      _completer.completeError(e);
    }
  }

  Future<dynamic> sendReceive(dynamic requestData) async {
    final rp = ReceivePort();
    final request = {
      "sendPort": rp.sendPort,
      "requestData": requestData,
    };
    _sendPort.send(request);
    final result = await rp.first;
    return result;
  }

  Future<bool> get ready => _completer.future;

  Isolate get isolate => _isolate;

  kill({int priority = Isolate.beforeNextEvent}) {
    _isolate.kill(priority: priority);
  }
}
