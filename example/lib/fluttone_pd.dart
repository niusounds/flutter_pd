import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pd/flutter_pd.dart';
import 'package:flutter_pd_example/fluttone.dart';

class FluttonePd extends StatefulWidget {
  const FluttonePd({
    Key? key,
  }) : super(key: key);

  @override
  State<FluttonePd> createState() => _FluttonePdState();
}

class _FluttonePdState extends State<FluttonePd> {
  final _pd = FlutterPd();
  PdFileHandle? _pdFileHandle;

  @override
  void initState() {
    super.initState();

    // Force landscape
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    _initializePd();
  }

  Future<void> _initializePd() async {
    await _pd.startPd();

    _pdFileHandle = await _pd.openAsset('assets/fluttone.pd');

    await _pd.startAudio(
      requireInput: false,
    );
  }

  @override
  void dispose() {
    _pdFileHandle?.close();
    _pd.stopPd();

    // Enable portrait
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.dark(),
      child: FluttoneUi(
        onPlayNote: _onPlayNote,
      ),
    );
  }

  // final notes = [62.0, 65.0, 69.0, 72.0, 74.0];

  void _onPlayNote(int note) {
    _pd.sendBang('note$note');
  }
}
