import 'dart:convert';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:timeline_editor/positioned_list_view.dart';
import 'package:timeline_editor/timeline.dart';
import 'package:timeline_editor/value_input.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Timeline editor',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
        )
      ),
      home: const TimeLineHome(),
    );
  }
}

class TimeLineHome extends StatefulWidget {
  const TimeLineHome({super.key});

  @override
  State<TimeLineHome> createState() => _TimeLineHomeState();
}

class _TimeLineHomeState extends State<TimeLineHome> {
  static const double _kDefaultUnitHeight = 20.0;

  Map<double, String> _eventsLeft = {
    100: 'data',
    110: 'data2',
  };
  Map<double, String> _eventsRight = {
    90: 'data',
  };

  double _scale = _kDefaultUnitHeight;

  /// The first time in both [_eventsLeft] and [_eventsRight]
  double? get _minTime => (_eventsLeft.isEmpty || _eventsRight.isEmpty)
      ? null
      : min(_eventsLeft.keys.min, _eventsRight.keys.min);

  /// The last time in both [_eventsLeft] and [_eventsRight]
  double? get _maxTime => (_eventsLeft.isEmpty || _eventsRight.isEmpty)
      ? null
      : max(_eventsLeft.keys.max, _eventsRight.keys.max);

  /// Difference between the earliest and the latest events on record.
  double get _eventsHeight => (_maxTime == null || _minTime == null)
      ? 0.0
      : (_maxTime! - _minTime!);

  late final TextEditingController leftTitleController;
  late final TextEditingController rightTitleController;

  @override
  void initState() {
    super.initState();
    leftTitleController = TextEditingController();
    rightTitleController = TextEditingController();
  }

  @override
  void dispose() {
    leftTitleController.dispose();
    rightTitleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      forceMaterialTransparency: true,
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: SizedBox(
              child: TextField(
                controller: leftTitleController,
                decoration: const InputDecoration(
                  hintText: 'Untitled left column',
                  border: UnderlineInputBorder()
                ),
              )
            ),
          ),
          IconButton(
            onPressed: () {
              try {
                final dataMap = {
                  'version': 1,
                  'scale': _scale,
                  'titleLeft': leftTitleController.text,
                  'titleRight': rightTitleController.text,
                  'entriesL': _eventsLeft.map((key, value) => MapEntry(key.toString(), value)),
                  'entriesR': _eventsRight.map((key, value) => MapEntry(key.toString(), value)),
                };
                Clipboard.setData(ClipboardData(text: jsonEncode(dataMap)));
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Snapshot copied to clipboard.')));
              } catch (e, stackTrace) {
                debugPrint(e.toString());
                debugPrint(stackTrace.toString());
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Failed to copy snapshot to clipboard: $e')));
              }
            },
            tooltip: 'Save',
            icon: const Icon(Icons.copy)
          ),
          IconButton(
            onPressed: () async {
              final messenger = ScaffoldMessenger.of(context);
              try {
                final data = await Clipboard.getData('text/plain');
                final dataMap = jsonDecode(data?.text ?? '');
                assert(dataMap['version'] == 1);
                setState(() {
                  _scale = dataMap['scale'];
                  leftTitleController.text = dataMap['titleLeft'];
                  rightTitleController.text = dataMap['titleRight'];
                  _eventsLeft = (dataMap['entriesL'] as Map<String, dynamic>)
                      .map((key, value) => MapEntry(double.parse(key), value));
                  _eventsRight = (dataMap['entriesR'] as Map<String, dynamic>)
                      .map((key, value) => MapEntry(double.parse(key), value));
                });
                messenger.showSnackBar(const SnackBar(
                    content: Text('Successfully loaded data from clipboard.')));
              } catch (e, stackTrace) {
                debugPrint(e.toString());
                debugPrint(stackTrace.toString());
                messenger.showSnackBar(SnackBar(
                    content: Text('Could not load data from clipboard: $e')));
              }

            },
            tooltip: 'Load',
            icon: const Icon(Icons.paste)
          ),
          Expanded(
            child: SizedBox(
              child: TextField(
                controller: rightTitleController,
                decoration: const InputDecoration(
                  hintText: 'Untitled right column',
                  border: UnderlineInputBorder(),
                ),
                textAlign: TextAlign.end,
              )
            ),
          ),
        ],
      ),
    ),
    extendBody: true,
    bottomNavigationBar: Row(
      children: [
        Container(
          color: Colors.white,
          width: MediaQuery.of(context).size.width / 2 - 16,
          child: ValueInput(
            callback: (year, note) {
              setState(() {
                _eventsLeft[year.toDouble()] = note;
              });
            }
          ),
        ),
        const Spacer(),
        Container(
          color: Colors.white,
          width: MediaQuery.of(context).size.width / 2 - 16,
          child: ValueInput(
            callback: (year, note) {
              setState(() {
                _eventsRight[year.toDouble()] = note;
              });
            }
          ),
        ),
      ]
    ),
    floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
    floatingActionButton: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 110,),
        IconButton.outlined(
          onPressed: () {
            setState(() {
              _scale *= 2;
            });
          },
          icon: const Icon(Icons.zoom_in)
        ),
        Text(_scale.toString()),
        IconButton.outlined(
            onPressed: () {
              setState(() {
                _scale /= 2;
                if (_scale <= 0) _scale = 1;
              });
            },
            icon: const Icon(Icons.zoom_out)
        ),
      ],
    ),
    body: SingleChildScrollView(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width / 2 - 20,
            height: _scale * _eventsHeight + 100,
            child: PositionedListView(
              unitHeight: _scale,
              startPos: _minTime ?? 0,
              children: _eventsLeft.map((key, value) => MapEntry(key, ListTile(
                title: Text(value),
                leading: Text(key.round().toString()),
              ))),
            ),
          ),
          SizedBox(
            height: _scale * _eventsHeight + 100,
            width: 40,
            child: TimeLine(
              unitHeight: _scale,
              minTime: _minTime ?? 0.0,
              maxTime: _maxTime ?? 1.0,
              stepSize: 10.0,
            ),
          ),
          SizedBox(
            height: _scale * _eventsHeight + 100,
            width: MediaQuery.of(context).size.width / 2 - 20,
            child: PositionedListView(
              unitHeight: _scale,
                startPos: _minTime ?? 0,
              children: _eventsRight.map((key, value) => MapEntry(key, ListTile(
                title: Text(value),
                leading: Text(key.round().toString()),
              )))
            ),
          ),
        ],
      ),
    )
  );
}
