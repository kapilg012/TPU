import 'package:flutter/material.dart';
import 'package:teen_patti_utility/player_add_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  DashboardScreenState createState() => DashboardScreenState();
}

class DashboardScreenState extends State<DashboardScreen> {
  TextEditingController totalController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
      ),
      body: getMainlayout,
    );
  }

  get getMainlayout => SafeArea(
        child: Column(
          children: [
            const SizedBox(
              height: 60,
            ),
            const Text("How Many players do yo want to play?"),
            const SizedBox(
              height: 60,
            ),
            TextField(
              controller: totalController,
            ),
            const SizedBox(
              height: 60,
            ),
            InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (ctx) {
                    return PlayerAddScreen();
                  }),
                );
              },
              child: Center(
                child: Container(
                  height: 30,
                  width: 100,
                  decoration: const BoxDecoration(color: Colors.orange),
                  child: const Center(
                    child: Text(
                      "Next",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      );
}
