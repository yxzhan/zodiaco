import 'package:flutter/foundation.dart';
// import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../utils/Configs.dart';

WebSocketsNotifications sockets = new WebSocketsNotifications();

class WebSocketsNotifications {
  static final WebSocketsNotifications _sockets =
      new WebSocketsNotifications._internal();

  factory WebSocketsNotifications() {
    return _sockets;
  }

  WebSocketsNotifications._internal();

  ///
  /// The WebSocket "open" channel
  ///
  WebSocketChannel _channel;

  ///
  /// Is the connection established?
  ///
  bool _isOn = false;

  ///
  /// Listeners
  /// List of methods to be called when a new message
  /// comes in.
  ///
  ObserverList<Function> _listeners = new ObserverList<Function>();

  ///
  /// Websocket server address
  ///
  // Future getServerAddress() async {
  //   for (var interface in await NetworkInterface.list()) {
  //     for (var addr in interface.addresses) {
  //       return 'ws://${addr.address}:23456';
  //     }
  //   }
  // }

  /// ----------------------------------------------------------
  /// Initialization the WebSockets connection with the server
  /// ----------------------------------------------------------
  initCommunication() async {
    ///
    /// Just in case, close any previous communication
    ///
    reset();
    const bool isProduction = bool.fromEnvironment('dart.vm.product');

    ///
    /// Open a new WebSocket communication
    ///
    try {
      String serverAddress =
          isProduction ? PROD_SERVER_ADDRESS : LOCAL_SERVER_ADDRESS;
      _channel = new WebSocketChannel.connect(Uri.parse(serverAddress));

      ///
      /// Start listening to new notifications / messages
      ///
      _channel.stream.listen(_onReceptionOfMessageFromServer, onDone: () {
        _reConnect();
      });
    } catch (e) {
      ///
      /// General error handling
      /// TODO
      ///
      print(e);
    }
  }

  /// ----------------------------------------------------------
  /// Closes the WebSocket communication
  /// ----------------------------------------------------------
  _reConnect() {
    Future.delayed(Duration(milliseconds: 1000)).then((_) {
      reset();
      initCommunication();
    });
  }

  /// ----------------------------------------------------------
  /// Closes the WebSocket communication
  /// ----------------------------------------------------------
  reset() {
    if (_channel != null) {
      if (_channel.sink != null) {
        _channel.sink.close();
        _isOn = false;
      }
    }
  }

  /// ---------------------------------------------------------
  /// Sends a message to the server
  /// ---------------------------------------------------------
  send(String message) {
    if (_channel != null) {
      if (_channel.sink != null && _isOn) {
        _channel.sink.add(message);
      }
    }
  }

  /// ---------------------------------------------------------
  /// Adds a callback to be invoked in case of incoming
  /// notification
  /// ---------------------------------------------------------
  addListener(Function callback) {
    _listeners.add(callback);
  }

  removeListener(Function callback) {
    _listeners.remove(callback);
  }

  /// ----------------------------------------------------------
  /// Callback which is invoked each time that we are receiving
  /// a message from the server
  /// ----------------------------------------------------------
  _onReceptionOfMessageFromServer(message) {
    _isOn = true;
    _listeners.forEach((Function callback) {
      callback(message);
    });
  }
}
