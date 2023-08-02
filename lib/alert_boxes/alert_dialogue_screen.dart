import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../common_widgets.dart';

class AlertDialogDetails extends StatefulWidget {
  int index;

  AlertDialogDetails(this.index, {super.key});

  @override
  State<AlertDialogDetails> createState() => _AlertDialogDetailsState();
}

class _AlertDialogDetailsState extends State<AlertDialogDetails> {
  final _box = Hive.box("sheet");
  List<dynamic> map = [];

  @override
  Widget build(BuildContext context) {
    map = _box.values.toList();
    var item = map[widget.index];

    return Scaffold(
      body: SizedBox(
        height: double.infinity,
        width: 500,
        child: ListView.builder(
                itemCount: item.keys.toList().length - 1,
                itemBuilder: (ctx, index) {
                  return singleItem(index, item);
                }),
      ),
    );
  }

  singleItem(index, item) {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: (item.values.toList()[index] >= 0) ? Colors.green : Colors.red,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: Colors.black, width: 5)),
      child: Column(
        children: [
          spacingVerticalNormal,
          Text(
            "${item.keys.toList()[index]}",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          Container(
            height: 2,
            width: 40,
            color: Colors.black,
          ),
          spacingVerticalNormal,
          Text(
            "${item.values.toList()[index]}",
            style: const TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          spacingVerticalNormal,
        ],
      ),
    );
  }
}
