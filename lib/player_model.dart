import 'package:flutter/material.dart';

class Player {
  final String name;
  bool? blind;
  int? chalTotal = 2;
  bool packed = false;

  Player(
      {required this.name,
      this.blind,
      this.chalTotal = 2,
      this.packed = false});
}
