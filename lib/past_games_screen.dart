import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

import 'alert_boxes/alert_dialogue.dart';
import 'alert_boxes/alert_dialogue_screen.dart';
import 'alert_erase_previous_data.dart';

class PastGamesScreen extends StatelessWidget {
  final _box = Hive.box("sheet");
  final _boxx = Hive.box("past");
  List<dynamic> map = [];

  @override
  Widget build(BuildContext context) {
    map = _box.values.toList();
    return Scaffold(
      appBar: AppBar(title: const Text("Previus Data"), actions: [
        IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  backgroundColor: Colors.transparent,
                  contentPadding: const EdgeInsets.only(right: 25, left: 25),
                  content: EraseDataAlert(),
                ),
              ).then((value) async {
                if (value) {
                  await _box.clear();
                  await _boxx.clear();
                  Navigator.pop(context);
                }
              });
            },
            icon: Icon(Icons.phonelink_erase))
      ]),
      body: getMainlayout(context),
    );
  }

  getMainlayout(context) => SafeArea(
      child: (_box.length == 0)
          ? const Center(child: Text("No Record Found"))
          : ListView.builder(
              shrinkWrap: true,
              //physics: const NeverScrollableScrollPhysics(),
              itemCount: _box.length,
              itemBuilder: (ctx, ind) {
                return getSingleItem(ind, context);
              }));

  getSingleItem(int index, context) {
    var item = map[index];
    print("Item${index + 1} ${item}");
    return Container(
      //height: 50,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(border: Border.all()),
      child: Row(
        children: [
          const SizedBox(
            width: 25,
          ),
          CircleAvatar(child: Text("${index + 1}")),
          const SizedBox(
            width: 50,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  height: 30,
                  width: 100,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.deepOrangeAccent),
                  child: Center(
                      child: Text(DateFormat('dd-MMM-yy')
                          .format(item.values.toList().last)))),
              Container(
                  height: 30,
                  width: 100,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.cyanAccent),
                  child: Center(
                    child: Text(
                        item.values.toList().last.toString().substring(11, 16)),
                  )),
            ],
          ),
          const SizedBox(
            width: 50,
          ),
          IconButton(
              onPressed: () => onDetailsPress(index, context),
              icon: const Icon(
                Icons.find_in_page,
                size: 50,
              ))
        ],
      ),
    );
  }

  onDetailsPress(index, context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.transparent,
        contentPadding: const EdgeInsets.only(right: 25, left: 5),
        content: AlertDialogDetails(index),
      ),
    );
  }
}
