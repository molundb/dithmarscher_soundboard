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
    'assets/images/tante_marianne.jpg',
    'assets/images/tante_marianne.jpg',
    'assets/images/tante_marianne.jpg',
    'assets/images/hackfleisch.jpg',
    'assets/images/dödodeldö.jpg',
    'assets/images/dodödeldi.jpg',
    'assets/images/idautit.jpeg',
    'assets/images/uwe.jpg',
  ];

  AudioCache audioCache;
  AudioPlayer audioPlayer;
  int indexIsPlaying;

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
        itemCount: 15,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 15,
          crossAxisSpacing: 15,
        ),
        itemBuilder: (BuildContext context, int index) => GestureDetector(
          child: Center(
            child: AnimatedContainer(
              width: indexIsPlaying == index ? 120 : 80,
              height: indexIsPlaying == index ? 120 : 80,
              duration: Duration(milliseconds: 400),
              curve: Curves.bounceOut,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: (index < _headshots.length)
                      ? AssetImage(_headshots[index])
                      : AssetImage(_headshots[0]),
                  fit: BoxFit.contain,
                ),
                borderRadius: new BorderRadius.circular(100.0),
                border: new Border.all(
                    color: indexIsPlaying == index
                        ? Colors.green
                        : Colors.transparent,
                    width: 2.0,
                    style: BorderStyle.solid),
                boxShadow: [
                  new BoxShadow(
                    color: Colors.grey.withOpacity(0.4),
                    offset: Offset(0, 10.0),
                    blurRadius: 10.0,
                  )
                ],
              ),
              child: Container(),
            ),
          ),
          onTap: () {
            if (mounted) {
              setState(() {
                (index < _sounds.length)
                    ? playSound(_sounds[index])
                    : playSound(_sounds[0]);
                indexIsPlaying = index;
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
