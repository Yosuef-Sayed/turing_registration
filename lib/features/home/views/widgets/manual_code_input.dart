// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class ManualCodeInput extends StatefulWidget {
  final Function(String) onSubmit;
  const ManualCodeInput({super.key, required this.onSubmit});

  @override
  State<ManualCodeInput> createState() => _ManualCodeInputState();
}

class _ManualCodeInputState extends State<ManualCodeInput> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: MediaQuery.sizeOf(context).width * 0.1,
      ),
      padding: const EdgeInsets.only(left: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: TextField(
        controller: _controller,
        style: const TextStyle(color: Colors.white, fontSize: 18),
        onSubmitted: (value) {
          if (value.isNotEmpty) {
            widget.onSubmit(value);
            _controller.clear();
          }
        },
        decoration: InputDecoration(
          hintText: "Enter Code",
          hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
          suffixIcon: IconButton(
            icon: const Icon(Icons.arrow_forward, color: Colors.white),
            onPressed: () {
              if (_controller.text.isNotEmpty) {
                widget.onSubmit(_controller.text);
                _controller.clear();
              }
            },
          ),
        ),
      ),
    );
  }
}
