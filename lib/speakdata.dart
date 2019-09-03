import 'dart:async';

import 'package:flutter_tts/flutter_tts.dart';

enum TtsState { playing, stopped }

class Speaker {
  FlutterTts flutterTts;
  int silencems;

  TtsState ttsState = TtsState.stopped;

  get isPlaying => ttsState == TtsState.playing;

  get isStopped => ttsState == TtsState.stopped;

  Speaker() {
    flutterTts = FlutterTts();

    flutterTts.setStartHandler(() {
      ttsState = TtsState.playing;
    });

    flutterTts.setCompletionHandler(() {
      print("Complete");
      ttsState = TtsState.stopped;
    });

    flutterTts.setErrorHandler((msg) {
      ttsState = TtsState.stopped;
    });
  }

  Future speak(String text) async {
    var result = await flutterTts.speak(text);
    if (result == 1) ttsState = TtsState.playing;
  }

  Future top() async {
    var result = await flutterTts.stop();
    if (result == 1) ttsState = TtsState.stopped;
  }

  void dispose() {
    flutterTts.stop();
  }
}
