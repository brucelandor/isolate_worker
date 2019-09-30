import 'dart:async';
import 'dart:isolate';

typedef MessageHandler = Function(SendPort sendPort);

class IsolateWorker {
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
      _isolate = await Isolate.spawn(messageHandler, rp.sendPort);
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

  kill({int priority: Isolate.beforeNextEvent}) {
    _isolate.kill(priority: priority);
  }
}
