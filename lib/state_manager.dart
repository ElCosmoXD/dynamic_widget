import 'package:dynamic_widget/pair.dart';
import 'package:flutter/material.dart';

class StateManager {
  // id / (widget / value).
  Map<int, Pair<Widget?, dynamic>> states;

  StateManager() : states = Map();

  bool hasWidget(int id) {
    return states.containsKey(id);
  }

  void createStateIfNotExists(int id, Widget? widget, dynamic value) {
    if(hasWidget(id)) {
      return;
    }

    states[id] = Pair(first: widget, second: value);
  }

  dynamic getStateValue(int id) => states[id]!.second;
  void setStateWidget(int id, Widget widget) => states[id]!.first = widget;
}
