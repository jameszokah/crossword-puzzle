import 'package:flutter/material.dart';

class CurrentDragObj {
  Offset? currentDragPos;
  Offset? currentTouch;
  int? indexArrayOnTouch;
  List<int?> currentDragLine = [];

  CurrentDragObj({
    required this.indexArrayOnTouch,
    required this.currentTouch,
  });
}