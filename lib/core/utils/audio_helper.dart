import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class AudioHelper {
  static final AudioHelper _instance = AudioHelper._internal();
  factory AudioHelper() => _instance;
  AudioHelper._internal();

  final AudioPlayer _audioPlayer = AudioPlayer();

  Future<void> playAudio(BuildContext context, String? audioPath) async {
    if (audioPath != null && audioPath.isNotEmpty) {
      try {
        await _audioPlayer.play(UrlSource(audioPath));
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Không thể phát âm thanh! 🔊')),
          );
        }
      }
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Từ này chưa có dữ liệu âm thanh! 🔊')),
        );
      }
    }
  }

  void dispose() {
    _audioPlayer.dispose();
  }
}
