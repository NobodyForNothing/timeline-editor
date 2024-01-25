import 'dart:async';

import 'package:flutter/material.dart';

typedef EntryCallback = FutureOr<void> Function(int position, String text);

class ValueInput extends StatelessWidget {
  const ValueInput({
    super.key,
    required this.callback,
  });

  final EntryCallback callback;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(
        flex: 2,
        child: TextField(
          decoration: InputDecoration(
            hintText: 'year'
          ),
        )
      ),
      const SizedBox(width: 4,),
      Expanded(
        flex: 7,
        child: TextField(
          decoration: InputDecoration(
              hintText: 'note'
          ),
        )
      ),
      IconButton(
        iconSize: 30,
        onPressed: () {
          // TODO
        },
        icon: const Icon(Icons.add_circle_outline)
      ),
    ],
  );

}