import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:teen_patti_utility/bloc/list_of_player_bloc.dart';
import 'package:teen_patti_utility/common_widgets.dart';
import 'package:teen_patti_utility/events/list_of_player_events.dart';
import 'package:teen_patti_utility/screens/RecordScreen.dart';
import 'package:teen_patti_utility/screens/past_games_screen.dart';
import 'package:teen_patti_utility/states/player_model.dart';

import '../alert_boxes/alert_dialogue.dart';
import '../states/PlayerListState.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  GameScreenState createState() => GameScreenState();
}

class GameScreenState extends State<GameScreen> {
  List<PlayerState>? listOfPlayers = [];
  var turn = 0;
  var bigSum = 0;
  var packedPlayerCount = 0;
  final _box = Hive.box("RecordList");
  var recordCount = 0;

  ListOfPlayerBloc? blocInstance;

  Future _addRow(Map<String, dynamic> row) async {
    await _box.add(row);
    log('Record Added' '${_box.values.toString()}');
  }

  Future _deleteRow(int key) async {
    await _box.deleteAt(1);
    log('Record' '${_box.values.toString()}');
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //listOfPlayers = widget.listOfPlayer;
    bigSum = listOfPlayers!.length * 2;
  }

  @override
  Widget build(BuildContext context) {
    blocInstance = BlocProvider.of<ListOfPlayerBloc>(context);
    return WillPopScope(
      onWillPop: () {
        return Future.value(false);
      },
      child: BlocBuilder(
          bloc: blocInstance,
          builder: (context, state) {
            return Scaffold(
              appBar: AppBar(
                title: const Text("Teen Patti "),
                actions: [
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.add)),
                  IconButton(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (ctx) {
                          return PastGamesScreen();
                        }));
                      },
                      icon: const Icon(Icons.receipt))
                ],
              ),
              backgroundColor: Colors.white,
              body: getMainlayout(state),
            );
          }),
    );
  }

  getMainlayout(state) => SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              getGrid(state),
              getWinnerButton(state),
              getChalBoard(state),
            ],
          ),
        ),
      );

  getGrid(PlayerListState state) => GridView.builder(
      padding: EdgeInsets.all(10),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: state.listOfPlayerState?.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          mainAxisExtent: 160),
      itemBuilder: (ctx, index) {
        return getSingleItem(index, state);
      });

  getSingleItem(index, PlayerListState state) {
    return InkWell(
      onTap: () {
        setState(() {
          turn = index;
        });
      },
      child: Container(
        decoration: BoxDecoration(
            color: (state.listOfPlayerState![index].packed)
                ? Colors.red
                : Colors.green,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
                width: 5, color: (turn == index) ? Colors.black : Colors.grey)),
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Container(
              ////height: 20,
              width: double.infinity,
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Colors.black26,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Center(
                child: Text(
                  state.listOfPlayerState![index].name,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
            ),
            Text(
              (state.listOfPlayerState![index].packed) ? "Packed" : "Playing",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              (state.listOfPlayerState![index].packed) ? "" : "Chaal",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Container(
              //height: 60,
              // width: 60,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.black, width: 5)),
              child: Center(
                child: Text(
                  "${state.listOfPlayerState?[index].chalTotal}",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: (!state.listOfPlayerState![index].packed)
                          ? Colors.green
                          : Colors.red),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  getChalBoard(PlayerListState state) {
    var list = state.listOfPlayerState;
    return Center(
      child: Container(
        //margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              "${state.listOfPlayerState?[turn].name}'s Turn",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () => onPress(2, state),
                  onLongPress: () => onLongPress(2, state),
                  child: const CircleAvatar(
                    radius: 25,
                    child: Text(
                      "2",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                InkWell(
                  onTap: () => onPress(4, state),
                  onLongPress: () => onLongPress(4, state),
                  child: const CircleAvatar(
                    radius: 25,
                    child: Text("4",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                InkWell(
                  onTap: () => onPress(8, state),
                  onLongPress: () => onLongPress(8, state),
                  child: const CircleAvatar(
                    radius: 25,
                    child: Text("8",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                InkWell(
                  onTap: () => onPress(16, state),
                  onLongPress: () => onLongPress(16, state),
                  child: const CircleAvatar(
                    radius: 25,
                    child: Text("16",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                InkWell(
                  onTap: () => onPress(32, state),
                  onLongPress: () => onLongPress(32, state),
                  child: const CircleAvatar(
                    radius: 25,
                    child: Text("32",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () => onPress(64, state),
                  onLongPress: () => onLongPress(64, state),
                  child: const CircleAvatar(
                    radius: 25,
                    child: Text("64",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                InkWell(
                  onTap: () => onPress(128, state),
                  onLongPress: () => onLongPress(128, state),
                  child: const CircleAvatar(
                    radius: 25,
                    child: Text("128",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                InkWell(
                  onTap: () => onPress(256, state),
                  onLongPress: () => onLongPress(256, state),
                  child: const CircleAvatar(
                    radius: 25,
                    child: Text("256",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                InkWell(
                  onTap: () => onPress(512, state),
                  onLongPress: () => onLongPress(512, state),
                  child: const CircleAvatar(
                    radius: 25,
                    child: Text("512",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      if (turn == (list!.length) - 1) {
                        turn = 0;
                      } else {
                        turn = turn + 1;
                      }
                    });
                  },
                  child: const CircleAvatar(
                    radius: 25,
                    child: Text(""),
                  ),
                )
              ],
            ),
            spacingVerticalNormal,
            getPackButton(state),
            getTotal()
          ],
        ),
      ),
    );
  }

  getPackButton(PlayerListState state) {
    var list = state.listOfPlayerState;
    return Row(
      children: [
        InkWell(
          onTap: () {
            if (state.listOfPlayerState![turn].packed) {
              packedPlayerCount--;
              setState(() {
                var chalTotal = list?[turn].chalTotal;
                list?[turn].packed = false;
                list?[turn].chalTotal = -chalTotal!;

                blocInstance?.add(addPlayer(list ?? []));
                getTurnRight(state);
              });
              return;
            }
            if (packedPlayerCount != list!.length - 1) {
              packedPlayerCount++;
              setState(() {
                var chalTotal = list?[turn].chalTotal;
                list?[turn].packed = true;
                list?[turn].chalTotal = -chalTotal!;
                blocInstance?.add(addPlayer(list ?? []));
                getTurnRight(state);
              });
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Badha Player pack?"),
                ),
              );
            }
          },
          child: Container(
            //height: 40,
            // width: 100,
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.black, width: 5)),
            child: const Center(
              child: Text(
                "PACK",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.black),
              ),
            ),
          ),
        ),
        InkWell(
          onTap: () {
            showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                backgroundColor: Colors.transparent,
                contentPadding: const EdgeInsets.only(right: 25, left: 25),
                content: AlertDialogueScreen([], true, false),
              ),
            ).then((value) {
              if (value) {
                packedPlayerCount = 0;
                var list = state.listOfPlayerState;

                for (int i = 0; i < list!.length; i++) {
                  list?[i].chalTotal = 2;
                  list?[i].packed = false;
                }
                bigSum = list!.length * 2;
                blocInstance?.add(addPlayer(list));
              }
            });
          },
          child: Container(
            // height: 40,
            //width: 100,
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.black, width: 5)),
            child: const Center(
              child: Text(
                "RESET",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.black),
              ),
            ),
          ),
        ),
        InkWell(
          onTap: () {
            if (recordCount != 0) {
              Navigator.push(context, MaterialPageRoute(builder: (ctx) {
                return RecordScreen(state.listOfPlayerState ?? []);
              }));
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Bhai pehla Ramo to khara"),
                ),
              );
            }
          },
          child: Container(
            //height: 40,
            //width: 100,
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.black, width: 5)),
            child: const Center(
              child: Text(
                "RECORD",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.black),
              ),
            ),
          ),
        )
      ],
    );
  }

  getTurnRight(PlayerListState state) {
    if (turn == (state.listOfPlayerState!.length) - 1) {
      turn = 0;
      var flag = true;
      listOfPlayers?.forEach((element) {
        if (!element.packed && flag) {
          turn = state.listOfPlayerState?.indexOf(element) ?? 0;
          flag = false;
        }
      });
    } else {
      var flag = true;
      turn = turn + 1;
      for (int i = 0; i < state.listOfPlayerState!.length; i++) {
        if (turn <= i && flag) {
          if (!state.listOfPlayerState![i].packed) {
            turn = i;
            flag = false;
          }
        }
      }
      if (flag) {
        turn = 0;
        var flag2 = true;
        state.listOfPlayerState?.forEach((element) {
          if (!element.packed && flag2) {
            turn = state.listOfPlayerState?.indexOf(element) ?? 0;
            flag2 = false;
          }
        });
      }
    }
  }

  getWinnerButton(PlayerListState state) {
    return InkWell(
      onLongPress: () {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            backgroundColor: Colors.transparent,
            contentPadding: const EdgeInsets.only(right: 25, left: 25),
            content: AlertDialogueScreen([], false, true),
          ),
        ).then((value) {
          if (value) {
            var list = state.listOfPlayerState;
            packedPlayerCount = 0;
            recordCount++;
            num twoTotal = 0;
            list?.forEach((element) {
              if (!element.packed) {
                twoTotal += element.chalTotal!;
              }
            });
            var total = state.listOfPlayerState?[turn].chalTotal;
            list?[turn].score = list[turn].score! + bigSum - total!;

            var count = 0;
            list?.forEach((element) {
              if (!element.packed) {
                count++;
              }
            });
            Map<String, int> mapRow = {};
            list?.forEach((element) {
              if (!element.packed) {
                mapRow[element.name] = (bigSum - twoTotal) ~/ count;
              } else {
                mapRow[element.name] = element.chalTotal ?? 0;
              }
            });

            _addRow(mapRow);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Winners Saved Successfully"),
              ),
            );

            for (int i = 0; i < list!.length; i++) {
              list?[i].chalTotal = 2;
              list?[i].packed = false;
            }
            bigSum = list!.length * 2;
            blocInstance?.add(addPlayer(list));
          }
        });
      },
      onTap: () {
        if (packedPlayerCount == (state.listOfPlayerState!.length - 1)) {
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              backgroundColor: Colors.transparent,
              contentPadding: const EdgeInsets.only(right: 25, left: 25),
              content: AlertDialogueScreen([], false, false),
            ),
          ).then((value) {
            var list = state.listOfPlayerState;
            if (value) {
              packedPlayerCount = 0;
              recordCount++;
              var total = list?[turn].chalTotal;
              list?[turn].score = list[turn].score! + bigSum - total!;

              Map<String, int> mapRow = {};
              list?.forEach((element) {
                if (list?.indexOf(element) == turn) {
                  mapRow[element.name] = bigSum - total!;
                } else {
                  mapRow[element.name] = element.chalTotal ?? 0;
                }
              });

              _addRow(mapRow);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Winner Saved Successfully"),
                ),
              );
              setState(() {
                for (int i = 0; i < list!.length; i++) {
                  list?[i].chalTotal = 2;
                  list?[i].packed = false;
                }
                bigSum = list!.length * 2;
              });
              blocInstance?.add(addPlayer(list!));
            }
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Bhai !! ऐसे केसे ???"),
            ),
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Colors.orangeAccent,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
                color:
                    (packedPlayerCount == (state.listOfPlayerState!.length - 1))
                        ? Colors.black
                        : Colors.grey,
                width: 5)),
        child: Text(
          "WINNER",
          style: TextStyle(
            color: (packedPlayerCount == (state.listOfPlayerState!.length - 1))
                ? Colors.black
                : Colors.grey,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  getTotal() {
    return Container(
      //height: 40,
      width: 100,
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.black, width: 5)),
      child: Center(
        child: Text(
          "$bigSum",
          style: const TextStyle(
              fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black),
        ),
      ),
    );
  }

  onPress(int i, PlayerListState state) {
    var list = state.listOfPlayerState;
    setState(() {
      if (!state.listOfPlayerState![turn].packed) {
        bigSum = bigSum + i;
        list?[turn].chalTotal =
            (state.listOfPlayerState?[turn].chalTotal ?? 0) + i;
      }

      getTurnRight(state);
    });
  }

  onLongPress(int num, PlayerListState state) {
    var list = state.listOfPlayerState;
    setState(() {
      if (!list![turn].packed) {
        bigSum = bigSum - num;
        list?[turn].chalTotal = (list?[turn].chalTotal ?? 0) - num;
      }

      if (turn == (list!.length) - 1) {
        turn = 0;
        var flag = true;
        list?.forEach((element) {
          if (!element.packed && flag) {
            turn = list?.indexOf(element) ?? 0;
            flag = false;
          }
        });
      } else {
        var flag = true;
        turn = turn + 1;
        for (int i = 0; i < list!.length; i++) {
          if (turn <= i && flag) {
            if (!list![i].packed) {
              turn = i;
              flag = false;
            }
          }
        }
        if (flag) {
          turn = 0;
          var flag2 = true;
          list?.forEach((element) {
            if (!element.packed && flag2) {
              turn = list?.indexOf(element) ?? 0;
              flag2 = false;
            }
          });
        }
      }
      blocInstance?.add(addPlayer(list));
    });
  }
}
