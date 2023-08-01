import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:teen_patti_utility/player_add_screen.dart';
import 'package:flutter/foundation.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var path = await getApplicationDocumentsDirectory();
  Hive.init(path.path);
  await Hive.openBox("RecordList");
  await Hive.openBox("past");
  await Hive.openBox("Sheet");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  final _boxx = Hive.box("past");
  final _box = Hive.box("sheet");
  bool flag = true;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    getInitialOperation();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PlayerAddScreen(),
    );
  }

  getInitialOperation() async {
    if (flag) {
      Map<dynamic, dynamic> value = {};
      if (_boxx.length == 0) {
        flag = false;
      } else if (_box.isEmpty) {
        value = _boxx.values.first;
        await _box.add(value);
      } else if (mapEquals(
          _boxx.values.toList().first, _box.values.toList().last)) {
        print("Do Nothing");
      } else {
        value = _boxx.values.first;
        await _box.add(value);
      }
      flag = false;
    }
  }
}
