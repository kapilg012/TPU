import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:teen_patti_utility/CommonWidgets.dart';
import 'package:teen_patti_utility/past_games_screen.dart';
import 'package:teen_patti_utility/player_model.dart';

class RecordScreen extends StatefulWidget {
  List<Player> listOfPlayers;

  RecordScreen(this.listOfPlayers, {Key? key}) : super(key: key);

  @override
  _RecordScreenState createState() => _RecordScreenState();
}

class _RecordScreenState extends State<RecordScreen> {
  final _boxx = Hive.box("past");
  final _box = Hive.box("RecordList");
  List _items = [];
  List<int> sum = [];

  @override
  void initState() {
    /*_boxx.values.toString();
    _boxx.clear();*/
    super.initState();
  }

  Future _addRow(Map<String, dynamic> row) async {
    await _boxx.add(row);
    log('Record Added' '${_boxx.values.toString()}');
  }

  @override
  Widget build(BuildContext context) {
    sum = [];
    _items = _box.keys.map((e) => _box.get(e)).toList();
    for (var element in _items) {
      for (int i = 0; i < widget.listOfPlayers.length; i++) {
        if (i == sum.length) {
          sum.add(0);
        }
        sum[i] = sum[i] + element[widget.listOfPlayers[i].name] as int;
      }
    }
    return WillPopScope(
      onWillPop: () async {
        await _boxx.clear();
        Map<String, dynamic> map = {};

        for (int i = 0; i < widget.listOfPlayers.length; i++) {
          map["${widget.listOfPlayers[i].name}"] = sum[i];

          print("${widget.listOfPlayers[i].name}...${sum[i]}");
        }
        map["Date"] = DateTime.now();
        _addRow(map);
        return (true);
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Record-Sheet"),
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
      ),
    );
  }

  get getMainlayout => SafeArea(
          child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: DataTable(
              headingRowColor: MaterialStateProperty.all(Colors.black12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 5),
              ),
              border: TableBorder.all(width: 2),
              columnSpacing: 12,
              columns: getColumn(),
              rows: [],
            ),
          ),
          Expanded(
            flex: (widget.listOfPlayers.length == 3) ? 2 : 1,
            child: SingleChildScrollView(
              child: SizedBox(
                // height: 400,
                width: double.infinity,
                child: DataTable(
                  headingRowHeight: 0,
                  dataRowHeight: 30,
                  headingRowColor: MaterialStateProperty.all(Colors.black12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 5),
                  ),
                  border: TableBorder.all(width: 2),
                  columnSpacing: 12,
                  columns: getEmptyColumn(),
                  rows: getRows(),
                ),
              ),
            ),
          ),
          getScore
        ],
      ));

  get getScore => Expanded(
        flex: 1,
        child: GridView.builder(
            shrinkWrap: true,
            //physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.listOfPlayers.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, mainAxisExtent: 150),
            itemBuilder: (ctx, index) {
              return SingleGridItem(index);
            }),
      );

  SingleGridItem(index) {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: (sum[index] >= 0) ? Colors.green : Colors.red,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: Colors.black, width: 5)),
      child: Column(
        children: [
          spacingVerticalNormal,
          Text(
            widget.listOfPlayers[index].name,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          Container(
            height: 2,
            width: 40,
            color: Colors.black,
          ),
          spacingVerticalNormal,
          Text(
            "${sum[index]}",
            style: const TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          spacingVerticalNormal,
        ],
      ),
    );
  }

  getColumn() {
    List<DataColumn> column = [];
    for (var element in widget.listOfPlayers) {
      column.add(
        DataColumn(
          label: Center(
            child: Text(
              element.name,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
        ),
      );
    }
    return column;
  }

  getEmptyColumn() {
    List<DataColumn> column = [];
    for (var element in widget.listOfPlayers) {
      column.add(
        DataColumn(
          label: Center(
            child: Text(
              element.name,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.transparent),
            ),
          ),
        ),
      );
    }
    return column;
  }

  getRows() {
    List<DataRow> listOfRow = [];
    for (int i = _items.length - 1; i >= 0; i--) {
      listOfRow.add(getDataRow(_items[i]));
    }
    return listOfRow;
  }

  getEmptyRows() {
    List<DataRow> listOfRow = [];
    for (var element in _items) {
      listOfRow.add(getEmptyDataRow(element));
    }
    return listOfRow;
  }

  getDataRow(Map<dynamic, dynamic> e) {
    List<DataCell> listOfDataCell = [];
    for (int i = 0; i < widget.listOfPlayers.length; i++) {
      listOfDataCell.add(DataCell(Center(
        child: Text(
          "${e[widget.listOfPlayers[i].name]}",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: (e[widget.listOfPlayers[i].name] < 0)
                  ? Colors.red
                  : Colors.green),
        ),
      )));
    }
    return DataRow(cells: listOfDataCell);
  }

  getEmptyDataRow(Map<dynamic, dynamic> e) {
    List<DataCell> listOfDataCell = [];
    for (int i = 0; i < widget.listOfPlayers.length; i++) {
      listOfDataCell.add(DataCell(Center(
        child: Text(
          "${e[widget.listOfPlayers[i].name]}",
          style: const TextStyle(
              fontWeight: FontWeight.bold, color: Colors.transparent),
        ),
      )));
    }
    return DataRow(cells: listOfDataCell);
  }
}
