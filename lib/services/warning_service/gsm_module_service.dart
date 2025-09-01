import 'dart:typed_data';
import 'package:flutter_libserialport/flutter_libserialport.dart';

class GsmModuleService {
  final String portName;
  late SerialPort _port;

  GsmModuleService(this.portName);

  bool open() {
    try {
      _port = SerialPort(portName);

      if (!_port.openReadWrite()) {
        print("❌ Failed to open $portName");
        return false;
      }

      final config = _port.config;
      config.baudRate = 9600;
      config.bits = 8;
      config.stopBits = 1;
      config.parity = 0;
      _port.config = config;

      print("✅ Connected to $portName");
      return true;
    } catch (e) {
      final ports = SerialPort.availablePorts;
      print("❌ Failed to open $portName");
      print("Available Ports: $ports");
      print("Error: $e");
      return false;
    }
  }

  Future<void> sendSms(String number, String message) async {
    print("📤 Sending SMS to $number");

    _writeCommand("AT+CMGF=1");
    await Future.delayed(const Duration(milliseconds: 500));

    _writeCommand('AT+CMGS="$number"');
    await Future.delayed(const Duration(milliseconds: 500));

    _writeRaw("$message${String.fromCharCode(26)}");
    await Future.delayed(const Duration(seconds: 3));
  }

  void _writeCommand(String cmd) {
    final bytes = Uint8List.fromList(("$cmd\r").codeUnits);
    _port.write(bytes);
    print("➡️ Sent: $cmd");
  }

  void _writeRaw(String data) {
    final bytes = Uint8List.fromList(data.codeUnits);
    _port.write(bytes);
    print("➡️ Sent raw: $data");
  }

  void close() {
    if (_port.isOpen) {
      _port.close();
      print("🔌 Disconnected from $portName");
    }
  }

  Future<void> sendSmsToMultiple(String numbers, String message) async {
    final list = numbers.split(",");
    for (final number in list) {
      await sendSms(number.trim(), message);
      await Future.delayed(const Duration(seconds: 3));
    }
  }
}
