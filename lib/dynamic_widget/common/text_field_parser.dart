import 'package:dynamic_widget/dynamic_widget.dart';
import 'package:dynamic_widget/dynamic_widget/utils.dart';

import 'package:flutter/material.dart';

class TextFieldParser extends WidgetParser {
  @override
  Widget parse(Map<String, dynamic> map, BuildContext buildContext,
      EventsListener? listener) {
    String? valueChangedEvent = map.containsKey("valueChangedEvent")
        ? map["valueChangedEvent"]
        : null;
  
    int widgetId = map.containsKey("id") ? map["id"] : -1;
    DynamicWidgetBuilder.stateManager
        .createStateIfNotExists(widgetId, null, "");

    var widget = TextField(
      obscureText: map.containsKey("obscureText") ? map["obscureText"] : false,
      obscuringCharacter: map.containsKey("obscuringCharacter")
          ? map["obscuringCharacter"]
          : "•",
      style: map.containsKey("style") ? parseTextStyle(map["style"]) : null,
      decoration: map.containsKey("decoration")
          ? parseInputDecoration(map["decoration"])
          : null,
      keyboardType: map.containsKey("keyboardType")
          ? parseTextInputType(map["keyboardType"])
          : TextInputType.text,
      inputFormatters: map.containsKey("inputFormatters")
          ? parseInputFormatters(map["inputFormatters"])
          : null,
      onChanged: (value) {
        listener?.onValueChanged(valueChangedEvent, widgetId, value);
        DynamicWidgetBuilder.stateManager.states[widgetId]!.second = value;
      },
    );

    DynamicWidgetBuilder.stateManager.setStateWidget(widgetId, widget);

    return widget;
  }

  @override
  Map<String, dynamic>? export(Widget? widget, BuildContext? buildContext) {
    var realWidget = widget as TextField;

    return <String, dynamic>{
      "type": widgetName,
      "id": -1,
      "obscureText": realWidget.obscureText,
      "obscuringCharacter": realWidget.obscuringCharacter,
      "style": exportTextStyle(realWidget.style),
      "decoration": realWidget.decoration != null
          ? exportInputDecoration(realWidget.decoration as InputDecoration)
          : null,
      "keyboardType": exportTextInputType(realWidget.keyboardType),
      "inputFormatters": realWidget.inputFormatters?.isNotEmpty ?? false
          ? realWidget.inputFormatters!.map((f) => exportInputFormatter(f)).toList()
          : [],
    };
  }

  @override
  String get widgetName => "TextField";

  @override
  Type get widgetType => TextField;
}
