import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio_session/audio_session.dart';
import 'package:palette_generator/palette_generator.dart';
import '../widgets/icon_widget.dart';
import '../widgets/player_ui.dart';
import '../widgets/stylish_title.dart';
import '../screens/dashboard/dashboard_screen.dart';
import '../data/music_data.dart';

class MyHomeScreen extends StatefulWidget {
  const MyHomeScreen({super.key, required this.title});

  final String title;

  @override
  State<MyHomeScreen> createState() => _MyHomeScreenState();
}

class _MyHomeScreenState extends State<MyHomeScreen>
    with SingleTickerProviderStateMixin {
  late AudioPlayer _audioPlayer;
  final List<Song> songs = MusicData.songs;
  bool isPlaying = false;
  int? currentSongIndex;
  double _progress = 0.0;

  Color _primaryColor = const Color(0xFFE53935);
  Color _secondaryColor = Colors.red.shade700;
  Color _textColor = Colors.white;

  @override
  void initState() {
    super.initState();
    _initAudioPlayer();
  }

  Future<void> _extractColorsFromAlbumArt() async {
    if (currentSongIndex == null || songs[currentSongIndex!].coverImage == null) {
      return;
    }

    setState(() {
    });

    try {
      ImageProvider imageProvider;
      if (songs[currentSongIndex!].coverImage!.startsWith('http')) {
        imageProvider = NetworkImage(songs[currentSongIndex!].coverImage!);
      } else {
        imageProvider = AssetImage(songs[currentSongIndex!].coverImage!);
      }

      final paletteGenerator = await PaletteGenerator.fromImageProvider(
        imageProvider,
      );

      if (mounted) {
        setState(() {
          _primaryColor =
              paletteGenerator.dominantColor?.color ??
              paletteGenerator.vibrantColor?.color ??
              const Color(0xFFE53935);

          _secondaryColor =
              paletteGenerator.mutedColor?.color ??
              _primaryColor.withOpacity(0.7);

          _textColor = _primaryColor.computeLuminance() > 0.5
              ? Colors.black
              : Colors.white;

        });
      }
    } catch (e) {
      debugPrint('Error extracting colors: $e');
      setState(() {
        _primaryColor = const Color(0xFFE53935);
        _secondaryColor = Colors.red.shade700;
        _textColor = Colors.white;
      });
    }
  }

  Future<void> _initAudioPlayer() async {
    _audioPlayer = AudioPlayer();

    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.music());

    _audioPlayer.playerStateStream.listen((state) {
      if (state.playing != isPlaying) {
        setState(() {
          isPlaying = state.playing;
        });
      }

      if (state.processingState == ProcessingState.completed) {
        playNextSong();
      }
    });

    _audioPlayer.positionStream.listen((position) {
      final duration = _audioPlayer.duration;
      if (duration != null && duration.inMilliseconds > 0) {
        setState(() {
          _progress = position.inMilliseconds / duration.inMilliseconds;
        });
      }
    });
  }

  Future<void> playSong(int index) async {
    if (currentSongIndex == index && isPlaying) {
      await _audioPlayer.pause();
      return;
    }

    try {
      if (songs[index].url.startsWith("assets/")) {
        await _audioPlayer.setAsset(songs[index].url);
      } else {
        await _audioPlayer.setUrl(songs[index].url);
      }

      currentSongIndex = index;

      await _extractColorsFromAlbumArt();

      await _audioPlayer.play();

      setState(() {
        isPlaying = true;
      });
    } catch (e) {
      debugPrint("Error playing song: ${e.toString()}");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red.shade700,
          content: Text('Error playing song: ${e.toString()}'),
        ),
      );
    }
  }

  void playNextSong() {
    if (currentSongIndex == null) {
      if (songs.isNotEmpty) playSong(0);
      return;
    }

    final nextIndex = (currentSongIndex! + 1) % songs.length;
    playSong(nextIndex);
  }

  void playPreviousSong() {
    if (currentSongIndex == null) {
      if (songs.isNotEmpty) playSong(0);
      return;
    }

    final previousIndex = (currentSongIndex! - 1 + songs.length) % songs.length;
    playSong(previousIndex);
  }

  void togglePlayPause() {
    if (currentSongIndex == null) {
      if (songs.isNotEmpty) playSong(0);
      return;
    }

    if (isPlaying) {
      _audioPlayer.pause();
      setState(() {
        isPlaying = false;
      });
    } else {
      _audioPlayer.play();
      setState(() {
        isPlaying = true;
      });
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: _primaryColor,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Icon(Icons.menu, color: _textColor),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        title: StylishMusicTitle(textColor: _textColor),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications, color: _textColor),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.search, color: _textColor),
            onPressed: () {},
          ),
        ],
        elevation: 4,
      ),
      body: Container(
        color: _primaryColor.withOpacity(0.1),
        child: Column(
          children: [
            const SizedBox(height: 16.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: CoolPlayerUI(
                isPlaying: isPlaying,
                currentSong: currentSongIndex != null
                    ? songs[currentSongIndex!]
                    : null,
                onPlayPause: togglePlayPause,
                onNext: playNextSong,
                onPrevious: playPreviousSong,
                progress: _progress,
                primaryColor: _primaryColor,
                secondaryColor: _secondaryColor,
                textColor: _textColor,
              ),
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: songs.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    color: index % 2 == 0
                        ? Colors.white
                        : _primaryColor.withOpacity(0.06),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: currentSongIndex == index
                            ? _primaryColor
                            : Colors.grey.shade300,
                        backgroundImage: songs[index].coverImage != null
                            ? (songs[index].coverImage!.startsWith('http')
                                  ? NetworkImage(songs[index].coverImage!)
                                  : AssetImage(songs[index].coverImage!)
                                        as ImageProvider)
                            : null,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            if (songs[index].coverImage == null)
                              Text('#${index + 1}'),
                            if (currentSongIndex == index)
                              Icon(
                                isPlaying ? Icons.pause : Icons.play_arrow,
                                color: Colors.white.withOpacity(0.8),
                                size: 20,
                              ),
                          ],
                        ),
                      ),
                      title: Text(songs[index].title),
                      subtitle: Text(songs[index].singer),
                      trailing: Icon(
                        currentSongIndex == index && isPlaying
                            ? Icons.pause_circle_filled
                            : Icons.music_note,
                        color: currentSongIndex == index
                            ? _primaryColor
                            : Colors.grey,
                      ),
                      onTap: () {
                        playSong(index);
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (currentSongIndex != null)
            StreamBuilder<Duration>(
              stream: _audioPlayer.positionStream,
              builder: (context, snapshot) {
                final position = snapshot.data ?? Duration.zero;
                final duration = _audioPlayer.duration ?? Duration.zero;
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(_formatDuration(position)),
                          Text(_formatDuration(duration)),
                        ],
                      ),
                    ),
                    Slider(
                      value: position.inMilliseconds.toDouble(),
                      max: duration.inMilliseconds > 0
                          ? duration.inMilliseconds.toDouble()
                          : 1.0,
                      activeColor: _primaryColor,
                      onChanged: (value) {
                        _audioPlayer.seek(
                          Duration(milliseconds: value.toInt()),
                        );
                      },
                    ),
                  ],
                );
              },
            ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MyIcon(
                  Icons.dashboard,
                  color: Colors.red.shade800,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const DashboardScreen(),
                      ),
                    );
                  },
                ),

                MyIcon(
                  isPlaying ? Icons.pause_circle : Icons.play_circle,
                  color: Colors.red,
                  size: 54.0,
                  onTap: togglePlayPause,
                ),

                MyIcon(
                  Icons.logout,
                  color: Colors.red.shade800,
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          backgroundColor: Colors.red.shade50,
                          title: const Text(
                            'Exit App',
                            style: TextStyle(color: Colors.red),
                          ),
                          content: const Text('Are you sure you want to exit?'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: Text(
                                'No',
                                style: TextStyle(color: Colors.red.shade700),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(true);
                              },
                              child: Text(
                                'Yes',
                                style: TextStyle(color: Colors.red.shade700),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
