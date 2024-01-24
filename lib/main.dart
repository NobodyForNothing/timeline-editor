import 'package:flutter/material.dart';
import 'package:timeline_editor/positioned_list_view.dart';

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
  late final ScrollController controllerLeft;
  late final ScrollController controllerRight;

  @override
  void initState() {
    super.initState();
    controllerLeft = ScrollController();
    controllerRight = ScrollController();
    
    controllerLeft.addListener(() {
      print('l: ${controllerLeft.offset}');
      controllerRight.jumpTo(controllerLeft.offset);
    });
    controllerRight.addListener(() {
      print('r: ${controllerRight.offset}');
      controllerLeft.jumpTo(controllerRight.offset);
    });
  }


  @override
  void dispose() {
    controllerLeft.dispose();
    controllerRight.dispose();
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
                  hintText: 'Unknown column left'
              ),
            )
          ),
          const Spacer(),
          SizedBox(
              width: MediaQuery.of(context).size.width / 2 - 18,
              child: const TextField(
                decoration: InputDecoration(
                  hintText: 'Unknown column right'
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
            controller: controllerLeft,
            children: {
              1: const ListTile(title: Text('1')),
              3: const ListTile(title: Text('2')),
              4: const ListTile(title: Text('3')),
              12: const ListTile(title: Text('A')),
              70: const ListTile(title: Text('4')),
            },
          ),
        ),
        const VerticalDivider(
          thickness: 3.0,
        ),
        Expanded(
          child: PositionedListView(
            unitHeight: 20,
            controller: controllerRight,
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
