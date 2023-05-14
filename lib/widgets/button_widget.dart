import 'package:flutter/material.dart';

class BeButton extends StatefulWidget {
  final String name;
  final Function callback;

  const BeButton({Key? key, required this.name, required this.callback}) : super(key: key);

  @override
  _BeButtonState createState() => _BeButtonState();
}

class _BeButtonState extends State<BeButton> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 150,
        height: 44,
        child: ElevatedButton(
          onPressed: () {
            widget.callback();
          },
          style: ElevatedButton.styleFrom(primary: Theme.of(context).secondaryHeaderColor),
          child: Text(
            widget.name,
            style: Theme.of(context).textTheme.button,
          ),
        ));
  }
}
