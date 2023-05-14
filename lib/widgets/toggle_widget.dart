import 'package:flutter/material.dart';
import 'package:flutter_toggle_tab/flutter_toggle_tab.dart';

class BeToggle extends StatefulWidget {
  final String name;
  final int currentIndex;
  final Function callback;

  const BeToggle({Key? key, required this.name, required this.currentIndex, required this.callback}) : super(key: key);

  @override
  _BeToggleState createState() => _BeToggleState();
}

class _BeToggleState extends State<BeToggle> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.name,
          style: const TextStyle(color: Colors.black87, fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(
          height: 10,
        ),
        FlutterToggleTab(
          width: 10,
          borderRadius: 25,
          selectedBackgroundColors: widget.currentIndex == 0 ? [Colors.greenAccent] : [Colors.redAccent],
          selectedTextStyle: const TextStyle(color: Colors.black54, fontSize: 18, fontWeight: FontWeight.w600),
          unSelectedTextStyle: const TextStyle(color: Colors.black54, fontSize: 14, fontWeight: FontWeight.w400),
          labels: const ["", ""],
          icons: const [Icons.check, Icons.close_rounded],
          selectedLabelIndex: (index) {
            widget.callback(index);
          },
          selectedIndex: widget.currentIndex,
        )
      ],
    );
  }
}
