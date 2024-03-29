import 'package:flutter/material.dart';

class TimeLine extends StatelessWidget {
  const TimeLine({
    super.key,
    required this.minTime,
    required this.maxTime,
    required this.stepSize,
    required this.unitHeight,
  }): assert(maxTime > minTime);

  final double minTime;
  final double maxTime;
  final double stepSize;

  /// How high one unit is rendered on the screen.
  final double unitHeight;

  static const double _kLabelHeight = 20;

  @override
  Widget build(BuildContext context) {
    double stepSize = this.stepSize;
    while ((stepSize * unitHeight) <= _kLabelHeight) {
      stepSize *= 2;
    }

    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      itemCount: ((maxTime - minTime) ~/ stepSize) * 2,
      itemBuilder: (BuildContext context, int idx) {
        if (idx % 2 == 1) {
          return SizedBox(
            height: (stepSize * unitHeight) - _kLabelHeight,
            child: const Center(
              child: VerticalDivider(
                thickness: 3.0,
              )
            )
          );
        }
        return SizedBox(
          height: _kLabelHeight,
          child: Center(
            child: Text((minTime + stepSize * (idx / 2)).round().toString())
          ),
        );
      },
    );
  }

}