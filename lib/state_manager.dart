import 'package:dynamic_widget/pair.dart';
import 'package:flutter/material.dart';

class StateManager {
  // id / (widget / value).
  Map<int, Pair<Widget?, dynamic>> states;

  StateManager() : states = Map();

  // Checks if a widget with the given id has been added
  bool hasWidget(int id) {
    return states.containsKey(id);
  }

  // Creates a state if it does not already exist
  void createStateIfNotExists(int id, Widget? widget, dynamic value) {
    if(hasWidget(id)) {
      return;
    }

    states[id] = Pair(first: widget, second: value);
  }

  // Clears all states. Only use this function when disposing the page state
  void clear() {
    states.clear();
  }

  dynamic getStateValue(int id) => states[id]!.second;
  void setStateWidget(int id, Widget widget) => states[id]!.first = widget;
}
