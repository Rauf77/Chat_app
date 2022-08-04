import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class SoundRecorder extends StatefulWidget {
  const SoundRecorder({Key? key}) : super(key: key);

  @override
  State<SoundRecorder> createState() => _SoundRecorderState();
}

class _SoundRecorderState extends State<SoundRecorder> {
  final recorder = FlutterSoundRecorder();

  @override
  void initState() {
    super.initState();
    initRecorder();
  }

  @override
  void dispose() {
    recorder.closeRecorder();
    super.dispose();
  }

  Future initRecorder() async {
    final status = await Permission.microphone.request();

    if (status != PermissionStatus.granted) {
      throw 'microphone permission not granted';
    }
    await recorder.openRecorder();
  }

  Future record() async {
    await recorder.startRecorder(toFile: 'audio');
  }

  Future stop() async {
    await recorder.stopRecorder();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          StreamBuilder<RecordingDisposition>(
            stream: recorder.onProgress,
            builder: (context, snapshot) {
              final duration =
                  snapshot.hasData ? snapshot.data!.duration : Duration.zero;
              String twoDigits(int n) => n.toString().padLeft(12);
              final twoDigitMinutes =
                  twoDigits(duration.inMinutes).codeUnitAt((9));
              final twoDigitsSeconds =
                  twoDigits(duration.inSeconds).codeUnitAt((9));

              return Text(
                '$twoDigitMinutes:$twoDigitsSeconds',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 80,
                  fontWeight: FontWeight.bold,
                ),
              );
            },
          ),
          SizedBox(
            height: 32,
          ),
          Center(
              child: Text(
            'click to start   recording ',
            style: TextStyle(color: Colors.white, fontSize: 20),
          )),
          Center(
            child: ElevatedButton(
              onPressed: () async {
                if (recorder.isRecording) {
                  await stop();
                } else {
                  await record();
                }
                setState(() {});
              },
              child: Icon(
                recorder.isRecording ? Icons.stop : Icons.mic,
                size: 50,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
