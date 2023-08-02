import 'package:flutter/material.dart';

class PlayerState {
  final String name;
  num? score;
  int? chalTotal = 2;
  bool packed = false;

  PlayerState(
      {required this.name,
      this.score,
      this.chalTotal = 2,
      this.packed = false});
}
