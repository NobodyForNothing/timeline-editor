import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

/// A list that allows positioning its children along the main axis.
///
/// Elements the space between widgets is ensured to be on a consistent scale.
///
/// The rendered position of the [children] is computed using their key
/// multiplied with the [unitHeight] to allow for scaling.
class PositionedListView extends StatelessWidget {
  /// Create a list that allows positioning its children.
  const PositionedListView({
    super.key,
    required this.children,
    required this.startPos,
    this.unitHeight = 1,
  });

  /// Map of the positions of the children and their content.
  final Map<double, Widget> children;

  /// Position where the scale starts.
  ///
  /// This might add empty space to the start of the list but will not remove
  /// elements if this is not the case.
  final double startPos;

  /// Height to draw for one unit in [children] keys.
  final double unitHeight;

  @override
  Widget build(BuildContext context) {
    final entries = children.entries.toList();
    entries.sort((a,b) => a.key.compareTo(b.key));
    final positions = entries.map((e) => e.key).toList();
    final values = entries.map((e) => e.value).toList();

    if (startPos < positions.min) {
      positions.insert(0, startPos);
      values.insert(0, const SizedBox());
    }

    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
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