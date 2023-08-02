import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:teen_patti_utility/common_widgets.dart';
import 'package:teen_patti_utility/screens/past_games_screen.dart';
import 'package:teen_patti_utility/player_model.dart';

import 'game_screen.dart';

class PlayerAddScreen extends StatefulWidget {
  static List<double> listOfPlayerScore = [];

  PlayerAddScreen();

  @override
  _PlayerAddScreenState createState() => _PlayerAddScreenState();
}

class _PlayerAddScreenState extends State<PlayerAddScreen> {
  List<Player> listOfPlayers = [];
  List<Player> listOfPlayersReverse = [];
  final _box = Hive.box("RecordList");
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    _box.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Players"),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (ctx) {
                  return PastGamesScreen();
                }));
              },
              icon: Icon(Icons.receipt))
        ],
      ),
      body: getMainlayout,
    );
  }

  get getMainlayout => SafeArea(
        child: Container(
          margin: const EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                children: [
                  const Text(
                    "Player Name:",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  SizedBox(
                    width: 100,
                    child: TextField(
                      controller: controller,
                    ),
                  ),
                  spacingHorizontalNormal,
                  addButton,
                ],
              ),
              const SizedBox(
                height: 100,
              ),
              getList,
              playButton
            ],
          ),
        ),
      );

  get getList {
    listOfPlayersReverse = List.from(listOfPlayers.reversed);
    return Expanded(
      child: ListView.builder(
          itemCount: listOfPlayersReverse.length,
          itemBuilder: (ctx, index) {
            return Container(
              height: 50,
              width: 100,
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.blueAccent,
              ),
              child: Center(
                child: Text(listOfPlayersReverse[index].name,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold)),
              ),
            );
          }),
    );
  }

  get addButton => InkWell(
        onTap: () {
          PlayerAddScreen.listOfPlayerScore.add(0);
          listOfPlayers.add(Player(name: controller.text));
          listOfPlayersReverse.add(Player(name: controller.text));
          controller.text = "";
          setState(() {});
        },
        child: Container(
          height: 40,
          width: 80,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.purpleAccent,
          ),
          child: const Center(
            child: Text(
              "ADD",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      );

  get refreshButton => InkWell(
        onTap: () {
          setState(() {});
        },
        child: Container(
          height: 40,
          width: 80,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.green,
          ),
          child: const Center(
            child: Text("REFRESH",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
          ),
        ),
      );

  get playButton => InkWell(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (ctx) {
            return GameScreen(listOfPlayers);
          }));
        },
        child: Container(
          height: 50,
          width: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.red,
          ),
          margin: const EdgeInsets.all(20),
          child: const Center(
              child: Text("PLAY",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
        ),
      );
}
