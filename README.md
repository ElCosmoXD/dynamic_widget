# Flutter Dynamic Widget
> A Backend-Driven UI toolkit, build your dynamic UI with json, and the json format is very similar with flutter widget code.

**Note**: This fork of dynamic_widget is meant to be used in the new application I'm making and many things are changed in comparison with the original package, so use it at your own risk.

## Table of contents
* [Install](#install)
* [Get started](#get-started)
* [How to implement a WidgetParser](#how-to-implement-a-widgetparser)
* [How to add an event listener](#how-to-add-an-event-listener)
* [How to write the json code](#how-to-write-the-json-code)
* [Widget Documents](#widget-documents)

## Install
#### 1. Depend on it
Add this to your package's pubspec.yaml file:

as a git package:
```
dependencies:
  dynamic_widget:
    git:
      url: https://github.com/ElCosmoXD/dynamic_widget.git
```

or as a local package:
```
dependencies:
  dynamic_widget:
    path: <path/to/the/package>
```

#### 2. Import it
Now in your Dart code, you can use:
```dart
import 'package:dynamic_widget/dynamic_widget.dart';
```

## Get started
You should use `DynamicWidgetBuilder().build` method to covert a json string into flutter widget. It will be time-consuming. so you'd better using `FutureBuilder` to build the UI.

```dart
import 'package:dynamic_widget/dynamic_widget.dart';

class PreviewPage extends StatelessWidget {
  final String jsonString;

  PreviewPage(this.jsonString);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text("Preview"),
      ),
      body: DynamicWidgetBuilder.build(jsonString, context, DefaultClickListener()) ?? Text("Error");
}
```
## How to implement a WidgetParser
1. You need to implement the `WidgetParser` abstract class.
2. Add new created WidgetParser by `DynamicWidgetBuilder.addParser(WidgetParser parser)` method.

This is a RaisedButton widget parser.
```dart
import 'package:dynamic_widget/dynamic_widget/utils.dart';
import 'package:dynamic_widget/dynamic_widget.dart';
import 'package:flutter/material.dart';

class RaisedButtonParser extends WidgetParser {
  @override
  String get widgetName => "RaisedButton";

  @override
  Widget parse(Map<String, dynamic> map, BuildContext buildContext, EventsListener listener) {
    String clickEvent =
        map.containsKey("click_event") ? map['click_event'] : "";

    var raisedButton = RaisedButton(
      color: map.containsKey('color') ? parseHexColor(map['color']) : null,
      disabledColor: map.containsKey('disabledColor')
          ? parseHexColor(map['disabledColor'])
          : null,
      disabledElevation:
          map.containsKey('disabledElevation') ? map['disabledElevation']?.toDouble() : 0.0,
      disabledTextColor: map.containsKey('disabledTextColor')
          ? parseHexColor(map['disabledTextColor'])
          : null,
      elevation: map.containsKey('elevation') ? map['elevation']?.toDouble() : 0.0,
      padding: map.containsKey('padding')
          ? parseEdgeInsetsGeometry(map['padding'])
          : null,
      splashColor: map.containsKey('splashColor')
          ? parseHexColor(map['splashColor'])
          : null,
      textColor:
          map.containsKey('textColor') ? parseHexColor(map['textColor']) : null,
      child: DynamicWidgetBuilder.buildFromMap(map['child'], buildContext, listener),
      onPressed: () {
        listener.onClicked(clickEvent);
      },
    );

    return raisedButton;
  }
}
```

Add it to parsers list.
```dart
DynamicWidgetBuilder.addParser(RaisedButtonParser());
```
## How to add an event listener
Add "click_event" property to your widget json definition. for example:
```dart
var raisedButton_json =
'''
{
  "type": "Container",
  "alignment": "center",
  "child": {
    "type": "RaisedButton",
    "color": "##FF00FF",
    "padding": "8,8,8,8",
    "textColor": "#00FF00",
    "elevation" : 8.0,
    "splashColor" : "#00FF00",
    "click_event" : "route://productDetail?goods_id=123",
    "child" : {
      "type": "Text",
      "data": "I am a button"
    }
  }
}
'''
```

We suggest you'd better to use an URI to define the event, as the exmaple, it's a event for going to a product detail page.

Then, define a EventsListener
```dart
class DefaultClickListener implements EventsListener {
  @override
  void onClicked(String? event, int id) {
    print("Receive click event: " + event);
  }
}
```

**Note**: If you see that your widget id is ``-1`` it's because you have to manually set the id as a property in the json of the Widget. This is because Flutter resets the view every time you change the state, so there's no way to create an automatic ID system without introducing new static variables.

Finally, pass the listener to build method.
```dart
  Widget? _buildWidget() {
    return DynamicWidgetBuilder.build(jsonString, buildContext, new DefaultClickListener());
  }
```

**THIS FORK ALSO SUPPORTS WIDGETS THAT NEED A STATE TO BE UPDATED ON SCREEN** you only need to define a callback to the ``setState`` function of a ``StatefulWidget`` and call it from ``onClick`` or ``onValueChanged``.

For widgets that have ``onChanged`` functions (like ``Slider``), you have to use the "value_changed_event" property in the json and ``onValueChanged`` to get the new values.

## How to write the json code
You don't need to write the json code by hand, you can export your flutter code to json code efficiently with DynamicWidgetJsonExportor widget. You just need to wrap your flutter code with DynamicWidgetJsonExportor widget, then invoke its `exportJsonString()` method, look at following example, click the "export" button, it will find the DynamicWidgetJsonExportor widget, and export its child to json code efficiently.

```dart
class _JSONExporterState extends State<JSONExporter> {
  GlobalKey key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text("export example"),
      ),
      body: Builder(
        builder: (context) => Column(
          children: [
            Expanded(
              child: DynamicWidgetJsonExportor(
                key: key,
                child: Container(
                  child: GridViewWidget(
                      GridViewParams(
                          mainAxisSpacing: 2.0,
                          crossAxisSpacing: 2.0,
                          crossAxisCount: 2,
                          childAspectRatio: 1.6,
                          padding: EdgeInsets.all(10.0),
                          pageSize: 10,
                          children: [
                            ListTile(
                              leading: Text("Leading text"),
                              title: Text("title"),
                              subtitle: Text("subtitle"),
                            ),
                            ListTile(
                              leading: Text("Leading text"),
                              title: Text("title"),
                              subtitle: Text("subtitle"),
                            )
                          ]),
                      context),
                ),
              ),
            ),
            RaisedButton(
              child: Text("Export"),
              onPressed: () {
                var exportor = key.currentWidget as DynamicWidgetJsonExportor;
                var exportJsonString = exportor.exportJsonString();
                Scaffold.of(context).showSnackBar(SnackBar(
                    content: Text("json string was exported to editor page.")));
                Future.delayed(Duration(seconds: 3), (){
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              CodeEditorPage(exportJsonString)));
                });
              },
            )
          ],
        ),
      ),
    );
  }
}
```
You can use whatever your favorite IDE to build the UI, then use DynamicWidgetJsonExportor to export to json code. For detail, please check the Dynamic Widget Demo source code.

<img src="./img/export.gif" width="320">

## Widget Documents
Already completed widgets:
* [Container](https://github.com/dengyin2000/dynamic_widget/blob/master/WIDGETS.md#container-widget)
* [Text](https://github.com/dengyin2000/dynamic_widget/blob/master/WIDGETS.md#text-widget)
* [TextSpan](https://github.com/dengyin2000/dynamic_widget/blob/master/WIDGETS.md#textspan)
* [TextStyle](https://github.com/dengyin2000/dynamic_widget/blob/master/WIDGETS.md#textstyle)
* [RaisedButton](https://github.com/dengyin2000/dynamic_widget/blob/master/WIDGETS.md#raisedbutton-widget)
* [ElevatedButton](https://github.com/dengyin2000/dynamic_widget/blob/master/WIDGETS.md#elevatedbutton-widget)
* [TextButton](https://github.com/dengyin2000/dynamic_widget/blob/master/WIDGETS.md#textbutton-widget)
* [Row](https://github.com/dengyin2000/dynamic_widget/blob/master/WIDGETS.md#row-widget)
* [Column](https://github.com/dengyin2000/dynamic_widget/blob/master/WIDGETS.md#column-widget)
* [AssetImage](https://github.com/dengyin2000/dynamic_widget/blob/master/WIDGETS.md#assetimage-widget)
* [NetworkImage](https://github.com/dengyin2000/dynamic_widget/blob/master/WIDGETS.md#networkimage-widget)
* [FileImage](https://github.com/dengyin2000/dynamic_widget/blob/master/WIDGETS.md#fileimage-widget)
* [Placeholder](https://github.com/dengyin2000/dynamic_widget/blob/master/WIDGETS.md#placeholder-widget)
* [GridView](https://github.com/dengyin2000/dynamic_widget/blob/master/WIDGETS.md#gridview-widget)
* [ListView](https://github.com/dengyin2000/dynamic_widget/blob/master/WIDGETS.md#listview-widget)
* [PageView](https://github.com/dengyin2000/dynamic_widget/blob/master/WIDGETS.md#pageview-widget)
* [Expanded](https://github.com/dengyin2000/dynamic_widget/blob/master/WIDGETS.md#expanded-widget)
* [Padding](https://github.com/dengyin2000/dynamic_widget/blob/master/WIDGETS.md#padding-widget)
* [Center](https://github.com/dengyin2000/dynamic_widget/blob/master/WIDGETS.md#center-widget)
* [Align](https://github.com/dengyin2000/dynamic_widget/blob/master/WIDGETS.md#align-widget)
* [AspectRatio](https://github.com/dengyin2000/dynamic_widget/blob/master/WIDGETS.md#aspectratio-widget)
* [FittedBox](https://github.com/dengyin2000/dynamic_widget/blob/master/WIDGETS.md#fittedbox-widget)
* [Baseline](https://github.com/dengyin2000/dynamic_widget/blob/master/WIDGETS.md#baseline-widget)
* [Stack](https://github.com/dengyin2000/dynamic_widget/blob/master/WIDGETS.md#stack-widget)
* [Positioned](https://github.com/dengyin2000/dynamic_widget/blob/master/WIDGETS.md#positioned-widget)
* [IndexedStack](https://github.com/dengyin2000/dynamic_widget/blob/master/WIDGETS.md#indexedstack-widget)
* [ExpandedSizedBox](https://github.com/dengyin2000/dynamic_widget/blob/master/WIDGETS.md#expandedsizedbox-widget)
* [SizedBox](https://github.com/dengyin2000/dynamic_widget/blob/master/WIDGETS.md#sizedbox-widget)
* [Opacity](https://github.com/dengyin2000/dynamic_widget/blob/master/WIDGETS.md#opacity-widget)
* [Wrap](https://github.com/dengyin2000/dynamic_widget/blob/master/WIDGETS.md#wrap-widget)
* [ClipRRect](https://github.com/dengyin2000/dynamic_widget/blob/master/WIDGETS.md#cliprrect-widget)
* [SafeArea](https://github.com/dengyin2000/dynamic_widget/blob/master/WIDGETS.md#safearea-widget)
* [SelectableText](https://github.com/dengyin2000/dynamic_widget/blob/master/WIDGETS.md#selectabletext-widget)
* [Icon](https://github.com/dengyin2000/dynamic_widget/blob/master/WIDGETS.md#icon-widget)
* [DropCapText](https://github.com/dengyin2000/dynamic_widget/blob/master/WIDGETS.md#dropcaptext-widget)
* [Scaffold](https://github.com/dengyin2000/dynamic_widget/blob/master/WIDGETS.md#scaffold-widget)
* [AppBar](https://github.com/dengyin2000/dynamic_widget/blob/master/WIDGETS.md#appbar-widget)
* [LimitedBox](https://github.com/dengyin2000/dynamic_widget/blob/master/WIDGETS.md#limitedbox-widget)
* [Offstage](https://github.com/dengyin2000/dynamic_widget/blob/master/WIDGETS.md#offstage-widget)
* [OverflowBox](https://github.com/dengyin2000/dynamic_widget/blob/master/WIDGETS.md#overflowbox-widget)
* [Divider](https://github.com/dengyin2000/dynamic_widget/blob/master/WIDGETS.md#divider-widget)
* [RotatedBox](https://github.com/dengyin2000/dynamic_widget/blob/master/WIDGETS.md#rotatedbox-widget)
* [SingleChildScrollView](https://github.com/dengyin2000/dynamic_widget/blob/master/WIDGETS.md#singlechildscrollview-widget)

You can view [Currently support widgets and properties](WIDGETS.md) here.

## Code Examples
~~Checkout this project and run demo.~~ The demos need to be updated, I don't think I will do it soon, so use the examples in this readme for now :)
