import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:dithmarscher_soundboard/sounds.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dithmarscher Soundboard',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: MyHomePage(title: 'Dithmarscher Soundboard'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> _headshots = [
    'assets/images/mike_pissed.jpeg',
  ];

  AudioCache audioCache;
  AudioPlayer audioPlayer;

  final List _sounds = Sounds().sounds;

  @override
  void initState() {
    super.initState();
    initSounds();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 15,
          crossAxisSpacing: 15,
        ),
        itemBuilder: (BuildContext context, int index) => GestureDetector(
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(_headshots[0]),
                fit: BoxFit.contain,
              ),
            ),
            child: Container(),
          ),
          onTap: () {
            if (mounted) {
              setState(() {
                playSound(_sounds[0]);
              });
            }
          },
        ),
        primary: false,
        padding: const EdgeInsets.all(30),
      ),
    );
  }

  void initSounds() async {
    audioPlayer = AudioPlayer();
    audioCache = AudioCache(fixedPlayer: audioPlayer);
    audioCache.loadAll(_sounds);
  }

  void playSound(sound) async {
    var fileName = sound;
    if (audioPlayer.state == AudioPlayerState.PLAYING) {
      audioPlayer.stop();
    }
    audioPlayer = await audioCache.play(fileName);
  }
}
