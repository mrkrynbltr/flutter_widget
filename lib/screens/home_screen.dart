import 'package:flutter/material.dart';
import '../widgets/icon_widget.dart';
import '../screens/dashboard/dashboard_screen.dart';

class MyHomeScreen extends StatefulWidget {
  const MyHomeScreen({super.key, required this.title});

  final String title;

  @override
  State<MyHomeScreen> createState() => _MyHomeScreenState();
}

class _MyHomeScreenState extends State<MyHomeScreen> {
  final List<Map<String, String>> songs = [
    {"title": "Bohemian Rhapsody", "singer": "Queen"},
    {"title": "Imagine", "singer": "John Lennon"},
    {"title": "Billie Jean", "singer": "Michael Jackson"},
    {"title": "Like a Rolling Stone", "singer": "Bob Dylan"},
    {"title": "Smells Like Teen Spirit", "singer": "Nirvana"},
    {"title": "Yesterday", "singer": "The Beatles"},
    {"title": "Breakeven", "singer": "The Script"},
    {"title": "Hey Jude", "singer": "The Beatles"},
    {"title": "Sweet Child O' Mine", "singer": "Guns N' Roses"},
    {"title": "Hotel California", "singer": "Eagles"},
    {"title": "Shape of You", "singer": "Ed Sheeran"},
    {"title": "Rolling in the Deep", "singer": "Adele"},
    {"title": "Uptown Funk", "singer": "Mark Ronson ft. Bruno Mars"},
    {"title": "Lose Yourself", "singer": "Eminem"},
    {"title": "Despacito", "singer": "Luis Fonsi ft. Daddy Yankee"},
    {"title": "Stairway to Heaven", "singer": "Led Zeppelin"},
    {"title": "What's Going On", "singer": "Marvin Gaye"},
  ];

  bool isPlaying = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1DA1F2),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        ),
        title: const Text('Widgets'),
        actions: [
          IconButton(icon: const Icon(Icons.notifications), onPressed: () {}),
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
        ],
      ),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            const SizedBox(height: 16.0),
            Container(
              padding: const EdgeInsets.only(top: 18.0),
              width: double.infinity,
              decoration: const BoxDecoration(color: Colors.white),
              child: Column(
                children: [
                  const Text(
                    'Flutter Widgets that demonstrate the use of Column.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Colors.black),
                  ),
                  const SizedBox(height: 16.0),
                  Image.network(
                    'https://cdn.ecoustics.com/db0/wblob/17BA35E873D594/311F/44D7F/m0q3Dn16hA4hxZwenzXGuQBDCTDe2BOvL1xNflZIC9A/spotify-logo-blue-background.png',
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(height: 16.0),
                ],
              ),
            ),
            Expanded(
                child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: songs.length,
                    itemBuilder: (BuildContext context, int index) {
                    return Container(
                      color: index % 2 == 0 ? Colors.white : Colors.blue.shade100,
                      child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.blue,
                        child: Text('#${index + 1}'),
                      ),
                      title: Text(songs[index]["title"]!),
                      subtitle: Text(songs[index]["singer"]!),
                      trailing: const Icon(Icons.music_note),
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                          'Playing ${songs[index]["title"]} by ${songs[index]["singer"]}',
                        ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            MyIcon(
              Icons.dashboard,
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
              color: Colors.green,
              size: 54.0,
              onTap: () {
                setState(() {
                  isPlaying = !isPlaying;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(isPlaying ? 'Playing music' : 'Paused music'),
                  ),
                );
              },
            ),

            MyIcon(
              Icons.logout,
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Exit App'),
                      content: const Text('Are you sure you want to exit?'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: const Text('No'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(true);
                          },
                          child: const Text('Yes'),
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
    );
  }
}
