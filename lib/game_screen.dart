import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:teen_patti_utility/common_widgets.dart';
import 'package:teen_patti_utility/RecordScreen.dart';
import 'package:teen_patti_utility/past_games_screen.dart';
import 'package:teen_patti_utility/player_add_screen.dart';
import 'package:teen_patti_utility/player_model.dart';

import 'alert_boxes/alert_dialogue.dart';

class GameScreen extends StatefulWidget {
  List<Player>? listOfPlayer;

  GameScreen(this.listOfPlayer, {Key? key}) : super(key: key);

  @override
  GameScreenState createState() => GameScreenState();
}

class GameScreenState extends State<GameScreen> {
  List<Player>? listOfPlayers = [];
  List<Player>? listOfPlayersTosend = [];
  List<Player>? listOfLostPlayer = [];
  List<List<Player>> listOfGames = [];
  var chal = 2;
  var turn = 0;
  var bigSum = 0;
  var packedPlayerCount = 0;
  final _box = Hive.box("RecordList");
  var recordCount = 0;

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
    listOfPlayers = widget.listOfPlayer;
    bigSum = listOfPlayers!.length * 2;
  }

  @override
  Widget build(BuildContext context) {
    //_box.clear();
    listOfPlayersTosend = widget.listOfPlayer;
    return WillPopScope(
      onWillPop: () {
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Teen Patti "),
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
        backgroundColor: Colors.white,
        body: getMainlayout,
      ),
    );
  }

  get getMainlayout => SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              getGrid,
              getWinnerButton,
              getChalBoard,
            ],
          ),
        ),
      );

  get getGrid => GridView.builder(
      padding: EdgeInsets.all(10),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: widget.listOfPlayer?.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          mainAxisExtent: 160),
      itemBuilder: (ctx, index) {
        return getSingleItem(index);
      });

  getSingleItem(index) {
    return InkWell(
      onTap: () {
        setState(() {
          turn = index;
        });
      },
      child: Container(
        decoration: BoxDecoration(
            color: (listOfPlayers![index].packed) ? Colors.red : Colors.green,
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
                  listOfPlayers![index].name,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
            ),
            Text(
              (listOfPlayers![index].packed) ? "Packed" : "Playing",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              (listOfPlayers![index].packed) ? "" : "Chaal",
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
                  "${listOfPlayers?[index].chalTotal}",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: (!listOfPlayers![index].packed)
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

  get getChalBoard => Center(
        child: Container(
          //margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Text(
                "${listOfPlayers?[turn].name}'s Turn",
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        if (!listOfPlayers![turn].packed) {
                          bigSum = bigSum + 2;
                          listOfPlayers?[turn].chalTotal =
                              (listOfPlayers?[turn].chalTotal ?? 0) + 2;
                        }

                        if (turn == (listOfPlayers!.length) - 1) {
                          turn = 0;
                          var flag = true;
                          listOfPlayers?.forEach((element) {
                            if (!element.packed && flag) {
                              turn = listOfPlayers?.indexOf(element) ?? 0;
                              flag = false;
                            }
                          });
                        } else {
                          var flag = true;
                          turn = turn + 1;
                          for (int i = 0; i < listOfPlayers!.length; i++) {
                            if (turn <= i && flag) {
                              if (!listOfPlayers![i].packed) {
                                turn = i;
                                flag = false;
                              }
                            }
                          }
                          if (flag) {
                            turn = 0;
                            var flag2 = true;
                            listOfPlayers?.forEach((element) {
                              if (!element.packed && flag2) {
                                turn = listOfPlayers?.indexOf(element) ?? 0;
                                flag2 = false;
                              }
                            });
                          }
                        }
                      });
                    },
                    onLongPress: () {
                      onLongPress(2);
                    },
                    child: const CircleAvatar(
                      radius: 25,
                      child: Text(
                        "2",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        if (!listOfPlayers![turn].packed) {
                          bigSum = bigSum + 4;
                          listOfPlayers?[turn].chalTotal =
                              (listOfPlayers?[turn].chalTotal ?? 0) + 4;
                        }
                        getTurnRight();
                      });
                    },
                    onLongPress: () {
                      onLongPress(4);
                    },
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
                    onTap: () {
                      setState(() {
                        if (!listOfPlayers![turn].packed) {
                          bigSum = bigSum + 8;
                          listOfPlayers?[turn].chalTotal =
                              (listOfPlayers?[turn].chalTotal ?? 0) + 8;
                        }
                        getTurnRight();
                      });
                    },
                    child: const CircleAvatar(
                      radius: 25,
                      child: Text("8",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                    onLongPress: () {
                      onLongPress(8);
                    },
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        if (!listOfPlayers![turn].packed) {
                          bigSum = bigSum + 16;
                          listOfPlayers?[turn].chalTotal =
                              (listOfPlayers?[turn].chalTotal ?? 0) + 16;
                        }
                        getTurnRight();
                      });
                    },
                    onLongPress: () {
                      onLongPress(16);
                    },
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
                    onTap: () {
                      setState(() {
                        if (!listOfPlayers![turn].packed) {
                          bigSum = bigSum + 32;
                          listOfPlayers?[turn].chalTotal =
                              (listOfPlayers?[turn].chalTotal ?? 0) + 32;
                        }
                        getTurnRight();
                      });
                    },
                    onLongPress: () {
                      onLongPress(32);
                    },
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
                    onTap: () {
                      setState(() {
                        if (!listOfPlayers![turn].packed) {
                          bigSum = bigSum + 64;
                          listOfPlayers?[turn].chalTotal =
                              (listOfPlayers?[turn].chalTotal ?? 0) + 64;
                        }

                        getTurnRight();
                      });
                    },
                    onLongPress: () {
                      onLongPress(64);
                    },
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
                    onTap: () {
                      setState(() {
                        if (!listOfPlayers![turn].packed) {
                          bigSum = bigSum + 128;
                          listOfPlayers?[turn].chalTotal =
                              (listOfPlayers?[turn].chalTotal ?? 0) + 128;
                        }
                        getTurnRight();
                      });
                    },
                    onLongPress: () {
                      onLongPress(128);
                    },
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
                    onTap: () {
                      setState(() {
                        if (!listOfPlayers![turn].packed) {
                          bigSum = bigSum + 256;
                          listOfPlayers?[turn].chalTotal =
                              (listOfPlayers?[turn].chalTotal ?? 0) + 256;
                        }
                        getTurnRight();
                      });
                    },
                    onLongPress: () {
                      onLongPress(256);
                    },
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
                    onTap: () {
                      setState(() {
                        if (!listOfPlayers![turn].packed) {
                          bigSum = bigSum + 512;
                          listOfPlayers?[turn].chalTotal =
                              (listOfPlayers?[turn].chalTotal ?? 0) + 512;
                        }
                        getTurnRight();
                      });
                    },
                    onLongPress: () {
                      onLongPress(512);
                    },
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
                        if (turn == (listOfPlayers!.length) - 1) {
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
              getPackButton(),
              getTotal()
            ],
          ),
        ),
      );

  getPackButton() {
    return Row(
      children: [
        InkWell(
          onTap: () {
            if (listOfPlayers![turn].packed) {
              packedPlayerCount--;
              setState(() {
                var chalTotal = listOfPlayers?[turn].chalTotal;
                listOfPlayers?[turn].packed = false;
                listOfPlayers?[turn].chalTotal = -chalTotal!;

                getTurnRight();
              });
              return;
            }
            if (packedPlayerCount != listOfPlayers!.length - 1) {
              packedPlayerCount++;
              setState(() {
                var chalTotal = listOfPlayers?[turn].chalTotal;
                listOfPlayers?[turn].packed = true;
                listOfPlayers?[turn].chalTotal = -chalTotal!;

                getTurnRight();
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
                content: AlertDialogueScreen(listOfPlayersTosend, true, false),
              ),
            ).then((value) {
              if (value) {
                packedPlayerCount = 0;
                setState(() {
                  for (int i = 0; i < listOfPlayers!.length; i++) {
                    listOfPlayers?[i].chalTotal = 2;
                    listOfPlayers?[i].packed = false;
                    listOfPlayers?[i].blind = true;
                  }
                  bigSum = listOfPlayers!.length * 2;
                });
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
                return RecordScreen(listOfPlayers!);
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

  getTurnRight() {
    if (turn == (listOfPlayers!.length) - 1) {
      turn = 0;
      var flag = true;
      listOfPlayers?.forEach((element) {
        if (!element.packed && flag) {
          turn = listOfPlayers?.indexOf(element) ?? 0;
          flag = false;
        }
      });
    } else {
      var flag = true;
      turn = turn + 1;
      for (int i = 0; i < listOfPlayers!.length; i++) {
        if (turn <= i && flag) {
          if (!listOfPlayers![i].packed) {
            turn = i;
            flag = false;
          }
        }
      }
      if (flag) {
        turn = 0;
        var flag2 = true;
        listOfPlayers?.forEach((element) {
          if (!element.packed && flag2) {
            turn = listOfPlayers?.indexOf(element) ?? 0;
            flag2 = false;
          }
        });
      }
    }
  }

  get getWinnerButton => InkWell(
        onLongPress: () {
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              backgroundColor: Colors.transparent,
              contentPadding: const EdgeInsets.only(right: 25, left: 25),
              content: AlertDialogueScreen(listOfPlayersTosend, false, true),
            ),
          ).then((value) {
            if (value) {
              packedPlayerCount = 0;
              recordCount++;
              var twoTotal = 0;
              listOfPlayers?.forEach((element) {
                if (!element.packed) {
                  twoTotal += element.chalTotal!;
                }
              });
              var total = listOfPlayers?[turn].chalTotal;
              PlayerAddScreen.listOfPlayerScore[turn] =
                  PlayerAddScreen.listOfPlayerScore[turn] + bigSum - total!;

              Map<String, int> mapRow = {};
              listOfPlayers?.forEach((element) {
                if (!element.packed) {
                  mapRow[element.name] = (bigSum - twoTotal) ~/ 2;
                } else {
                  mapRow[element.name] = element.chalTotal ?? 0;
                }
              });

              _addRow(mapRow);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Two Winners Saved Successfully"),
                ),
              );
              setState(() {
                for (int i = 0; i < listOfPlayers!.length; i++) {
                  listOfPlayers?[i].chalTotal = 2;
                  listOfPlayers?[i].packed = false;
                  listOfPlayers?[i].blind = true;
                }
                bigSum = listOfPlayers!.length * 2;
              });
            }
          });
        },
        onTap: () {
          if (packedPlayerCount == (listOfPlayers!.length - 1)) {
            showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                backgroundColor: Colors.transparent,
                contentPadding: const EdgeInsets.only(right: 25, left: 25),
                content: AlertDialogueScreen(listOfPlayersTosend, false, false),
              ),
            ).then((value) {
              if (value) {
                packedPlayerCount = 0;
                recordCount++;
                var total = listOfPlayers?[turn].chalTotal;
                PlayerAddScreen.listOfPlayerScore[turn] =
                    PlayerAddScreen.listOfPlayerScore[turn] + bigSum - total!;

                Map<String, int> mapRow = {};
                listOfPlayers?.forEach((element) {
                  if (listOfPlayers?.indexOf(element) == turn) {
                    mapRow[element.name] = bigSum - total;
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
                  for (int i = 0; i < listOfPlayers!.length; i++) {
                    listOfPlayers?[i].chalTotal = 2;
                    listOfPlayers?[i].packed = false;
                    listOfPlayers?[i].blind = true;
                  }
                  bigSum = listOfPlayers!.length * 2;
                });
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
                  color: (packedPlayerCount == (listOfPlayers!.length - 1))
                      ? Colors.black
                      : Colors.grey,
                  width: 5)),
          child: Text(
            "WINNER",
            style: TextStyle(
              color: (packedPlayerCount == (listOfPlayers!.length - 1))
                  ? Colors.black
                  : Colors.grey,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );

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

  onLongPress(int num) {
    setState(() {
      if (!listOfPlayers![turn].packed) {
        bigSum = bigSum - num;
        listOfPlayers?[turn].chalTotal =
            (listOfPlayers?[turn].chalTotal ?? 0) - num;
      }

      if (turn == (listOfPlayers!.length) - 1) {
        turn = 0;
        var flag = true;
        listOfPlayers?.forEach((element) {
          if (!element.packed && flag) {
            turn = listOfPlayers?.indexOf(element) ?? 0;
            flag = false;
          }
        });
      } else {
        var flag = true;
        turn = turn + 1;
        for (int i = 0; i < listOfPlayers!.length; i++) {
          if (turn <= i && flag) {
            if (!listOfPlayers![i].packed) {
              turn = i;
              flag = false;
            }
          }
        }
        if (flag) {
          turn = 0;
          var flag2 = true;
          listOfPlayers?.forEach((element) {
            if (!element.packed && flag2) {
              turn = listOfPlayers?.indexOf(element) ?? 0;
              flag2 = false;
            }
          });
        }
      }
    });
  }
}
