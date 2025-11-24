import 'package:dynamic_widget/dynamic_widget.dart';

import 'package:flutter/material.dart';

class SliderParser extends WidgetParser {
  @override
  Widget parse(Map<String, dynamic> map, BuildContext buildContext,
      EventsListener? listener) {
    String valueChangedEvent = map.containsKey("value_changed_event")
        ? map["value_changed_event"]
        : "";

    int widgetId = map.containsKey("id") ? map["id"] : -1;
    double value = map.containsKey("value") ? map["value"] : 0.0;

    // Even though is kind of weird to create the state with a null widget, this is
    // required to keep the value of the widget.
    DynamicWidgetBuilder.stateManager.createStateIfNotExists(widgetId, null, value);

    var widget = Slider(
        value: DynamicWidgetBuilder.stateManager.getStateValue(widgetId),
        min: map.containsKey("min") ? map["min"] : 0.0,
        max: map.containsKey("max") ? map["max"] : 1.0,

        onChanged: (value) {
          listener?.onValueChanged(
              valueChangedEvent, widgetId, value);
        
          DynamicWidgetBuilder.stateManager.states[widgetId]!.second = value;
        });

    DynamicWidgetBuilder.stateManager.setStateWidget(widgetId, widget);

    return widget;
  }

  @override
  Map<String, dynamic>? export(Widget? widget, BuildContext? buildContext) {
    final realWidget = widget as Slider;

    return <String, dynamic> {
      "type": widgetName,
      "value": realWidget.value,
      "min": realWidget.min,
      "max": realWidget.max
    };
  }

  @override
  String get widgetName => "Slider";

  @override
  Type get widgetType => Slider;
}
