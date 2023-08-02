import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:teen_patti_utility/common_widgets.dart';
import 'package:teen_patti_utility/events/list_of_player_events.dart';
import 'package:teen_patti_utility/screens/past_games_screen.dart';
import 'package:teen_patti_utility/states/player_model.dart';

import '../bloc/list_of_player_bloc.dart';
import '../states/PlayerListState.dart';
import 'game_screen.dart';

class PlayerAddScreen extends StatefulWidget {
  static List<double> listOfPlayerScore = [];

  PlayerAddScreen();

  @override
  _PlayerAddScreenState createState() => _PlayerAddScreenState();
}

class _PlayerAddScreenState extends State<PlayerAddScreen> {
  List<PlayerState> listOfPlayers = [];
  List<PlayerState> listOfPlayersReverse = [];
  final _box = Hive.box("RecordList");
  TextEditingController controller = TextEditingController();
  ListOfPlayerBloc? blocInstance;

  @override
  void initState() {
    _box.clear();
  }

  @override
  Widget build(BuildContext context) {
    blocInstance = BlocProvider.of<ListOfPlayerBloc>(context);
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
    return BlocBuilder(
      bloc: blocInstance,
      builder: (context, PlayerListState state) {
        listOfPlayersReverse = state.listOfPlayerState ?? [];
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
      },
    );
  }

  get addButton => InkWell(
        onTap: () {
          // PlayerAddScreen.listOfPlayerScore.add(0);
          listOfPlayers.add(PlayerState(name: controller.text));
          listOfPlayersReverse
              .add(PlayerState(name: controller.text, score: 0, packed: false));
          blocInstance?.add(addPlayer(listOfPlayersReverse));

          controller.text = "";
          //setState(() {});
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

  get playButton => InkWell(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (ctx) {
            return GameScreen();
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
