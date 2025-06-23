import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1DA1F2),
        title: const Text('Dashboard Screen'),
      ),
      body: Container(
        decoration: BoxDecoration(color: Colors.blue.shade100),
        width: double.infinity,
        child: Column(
          children: [
            const SizedBox(height: 16.0),
            Container(
              padding: const EdgeInsets.only(top: 24),
              width: double.infinity,
              decoration: const BoxDecoration(color: Colors.white),
              child: const Column(
                children: [
                  Text(
                    'Flutter Widgets that demonstrates the use of ListView with Horizontal Scroll.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
            SizedBox(
              height: 150,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.zero,
                children: List.generate(10, (index) {
                  return Container(
                    width: 100,
                    margin: const EdgeInsets.all(0),
                    decoration: BoxDecoration(
                      color: index % 2 == 0
                          ? Colors.blue.shade200
                          : Colors.blue.shade400,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Center(
                      child: Text(
                        'Item ${index + 1}',
                        style: TextStyle(
                          color: index % 2 == 0
                              ? Colors.white
                              : Colors.blue.shade900,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 16.0),
            Container(
              padding: const EdgeInsets.only(top: 24),
              width: double.infinity,
              decoration: const BoxDecoration(color: Colors.white),
              child: const Column(
                children: [
                  Text(
                    'And this is ListView with Vertical Scroll.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: 10,
                itemBuilder: (context, index) {
                  return Container(
                    color: index % 2 == 0 ? Colors.blue.shade100 : Colors.white,
                    margin: const EdgeInsets.only(bottom: 1.0),
                    child: ListTile(
                      leading: const Icon(
                        Icons.play_arrow,
                        color: Colors.blue,
                        size: 40.0,
                      ),
                      title: Text('Name ${index + 1}'),
                      subtitle: Text('Subtitle for item ${index + 1}'),
                      trailing: IconButton(
                        icon: index % 2 == 0
                            ? const Icon(
                                Icons.person,
                                color: Colors.red,
                                size: 30,
                              )
                            : const SizedBox(
                                width: 30,
                                height: 30,
                                child: Icon(
                                  Icons.person_off,
                                  color: Colors.red,
                                  size: 30,
                                ),
                              ),
                        onPressed: () {},
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
