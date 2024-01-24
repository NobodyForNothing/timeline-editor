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
  // String? titleLeft, titleRight;


  late final ScrollController _controllerLeft;
  late final ScrollController _controllerCenter;
  late final ScrollController _controllerRight;

  @override
  void initState() {
    super.initState();
    _controllerLeft = ScrollController();
    _controllerCenter = ScrollController();
    _controllerRight = ScrollController();


    _controllerLeft.addListener(() {
      _controllerCenter.jumpTo(_controllerLeft.offset);
      _controllerRight.jumpTo(_controllerLeft.offset);
    });
    _controllerCenter.addListener(() {
      _controllerLeft.jumpTo(_controllerRight.offset);
      _controllerRight.jumpTo(_controllerLeft.offset);
    });
    _controllerRight.addListener(() {
      _controllerLeft.jumpTo(_controllerRight.offset);
      _controllerCenter.jumpTo(_controllerLeft.offset);
    });
  }


  @override
  void dispose() {
    _controllerLeft.dispose();
    _controllerRight.dispose();
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
    body: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: PositionedListView(
            unitHeight: 20,
            controller: _controllerLeft,
            children: {
              1: const ListTile(title: Text('1')),
              3: const ListTile(title: Text('2')),
              4: const ListTile(title: Text('3')),
              12: const ListTile(title: Text('A')),
              70: const ListTile(title: Text('4')),
            },
          ),
        ),
        SizedBox(
          height: 300 * 20,
          width: 40,
          child: TimeLine(
            controller: _controllerCenter,
            unitHeight: 20,
            minTime: 0,
            maxTime: 300,
            stepSize: 10,
          ),
        ),
        Expanded(
          child: PositionedListView(
            unitHeight: 20,
            controller: _controllerRight,
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
    )
  );
}
