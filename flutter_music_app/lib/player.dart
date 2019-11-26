import 'package:audioplayer/audioplayer.dart';
import 'package:flute_music_player/flute_music_player.dart';

AudioPlayer audioPlayer = AudioPlayer();

var songs;

Song curMusic;

int curPosition = 0;


play() async {
  await audioPlayer.play(curMusic.uri, isLocal: true);
}

pause() async {
  await audioPlayer.pause();
}

stop() async {
  await audioPlayer.stop();
}

previous() async {
  if (curPosition != 0) {
    curPosition--;
    curMusic = songs[curPosition];
    stop();
    play();
  }
}

next() async {
  if (curPosition != songs.length - 1) {
    curPosition++;
    curMusic = songs[curPosition];
    stop();
    play();
  }
}
