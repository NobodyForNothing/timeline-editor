import 'dart:async';

import 'package:flutter/material.dart';

typedef EntryCallback = FutureOr<void> Function(int position, String text);

class ValueInput extends StatefulWidget {
  const ValueInput({
    super.key,
    required this.callback,
  });

  final EntryCallback callback;

  @override
  State<ValueInput> createState() => _ValueInputState();
}

class _ValueInputState extends State<ValueInput> {
  late final TextEditingController _yearController;
  late final TextEditingController _noteController;

  @override
  void initState() {
    super.initState();
    _yearController = TextEditingController();
    _noteController = TextEditingController();
  }

  @override
  void dispose() {
    _yearController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(6),
    child: Row(
      children: [
        Expanded(
          flex: 2,
          child: TextField(
            controller: _yearController,
            decoration: const InputDecoration(
              hintText: 'year'
            ),
          )
        ),
        const SizedBox(width: 4,),
        Expanded(
          flex: 7,
          child: TextField(
            controller: _noteController,
            decoration: const InputDecoration(
              hintText: 'note',
            ),
          )
        ),
        IconButton(
          iconSize: 30,
          onPressed: () {
            final year = int.tryParse(_yearController.text);
            final note = _noteController.text;
            widget.callback(year ?? 0, note);
            _yearController.clear();
            _noteController.clear();
          },
          icon: const Icon(Icons.add_circle_outline)
        ),
      ],
    ),
  );
}