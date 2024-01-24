import 'package:flutter/material.dart';

class PositionedListView extends StatelessWidget {
  const PositionedListView({
    super.key,
    required this.children,
    this.unitHeight = 1,
    this.controller,
  });

  final Map<double, Widget> children;

  final double unitHeight;

  final ScrollController? controller;

  @override
  Widget build(BuildContext context) {
    final positions = children.keys.toList();
    final values = children.values.toList();
    return ListView.builder(
      controller: controller,
      itemCount: positions.length,
      itemBuilder: (BuildContext context, int index) {
        if (positions.length == (index + 1)) return values[index];
        final availableVerticalUnits = positions[index + 1] - positions[index];
        return SizedBox(
          height: availableVerticalUnits * unitHeight,
          child: values[index],
        );
      }
    );
  }}