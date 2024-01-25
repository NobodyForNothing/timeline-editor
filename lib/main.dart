import 'package:flutter/material.dart';
import 'package:timeline_editor/positioned_list_view.dart';
import 'package:timeline_editor/timeline.dart';

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
  static const double _kUnitHeight = 10.0;

  // String? titleLeft, titleRight;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width / 2 - 18,
            child: const TextField(
              decoration: InputDecoration(
                  hintText: 'Untitled left column'
              ),
            )
          ),
          const Spacer(),
          SizedBox(
              width: MediaQuery.of(context).size.width / 2 - 18,
              child: const TextField(
                decoration: InputDecoration(
                  hintText: 'Untitled right column'
                ),
                textAlign: TextAlign.end,
              )
          ),
        ],
      ),
    ),
    body: SingleChildScrollView(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width / 2 - 20,
            height: _kUnitHeight * 70 + 100,
            child: PositionedListView(
              unitHeight: _kUnitHeight,
              children: {
                1: const ListTile(title: Text('1')),
                3: const ListTile(title: Text('2')),
                4: const ListTile(title: Text('3')),
                12: const ListTile(title: Text('A')),
                70: const ListTile(title: Text('4')),
              },
            ),
          ),
          const SizedBox(
            height: 300.0 * _kUnitHeight,
            width: 40,
            child: TimeLine(
              unitHeight: _kUnitHeight,
              minTime: 0,
              maxTime: 300,
              stepSize: 10,
            ),
          ),
          SizedBox(
            height: _kUnitHeight * 70 + 100,
            width: MediaQuery.of(context).size.width / 2 - 20,
            child: PositionedListView(
              unitHeight: _kUnitHeight,
              children: {
                1: const ListTile(title: Text('1')),
                3: const ListTile(title: Text('2')),
                4: const ListTile(title: Text('3')),
                10: const ListTile(title: Text('B')),
                70: const ListTile(title: Text('4')),
              },
            ),
          ),
        ],
      ),
    )
  );
}
