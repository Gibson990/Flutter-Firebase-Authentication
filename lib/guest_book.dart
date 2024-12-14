import 'dart:async';
import 'package:flutter/material.dart';

class GuestBook extends StatefulWidget {
  const GuestBook({super.key, required this.addMessage});

  final FutureOr<void> Function(String addMessage) addMessage;

  @override
  State<GuestBook> createState() => _GuestBookState();
}

class _GuestBookState extends State<GuestBook> {
  final _formKey = GlobalKey<FormState>(debugLabel: "_GuestBookState");
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Form(
        key: _formKey,
        child: Row(
          children: [
            Expanded(
                child: TextFormField(
              controller: _controller,
              decoration: const InputDecoration(hintText: "Write here!"),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter some text";
                }
              },
            )),
            const SizedBox(width: 8),
            ElevatedButton(
              child: const Row(
                children: [
                  Icon(Icons.send),
                  Text("SEND"),
                ],
              ),
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  await widget.addMessage(_controller.text);
                  _controller.text = "";
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
