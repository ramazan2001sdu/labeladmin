import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class BeColorPicker extends StatefulWidget {
  final String name;
  final Color currentColor;
  final Function callback;

  const BeColorPicker({Key? key, required this.name, required this.currentColor, required this.callback}) : super(key: key);

  @override
  _BeColorPickerState createState() => _BeColorPickerState();
}

class _BeColorPickerState extends State<BeColorPicker> {
  final textController = TextEditingController(text: '');
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
        GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Select a color'),
                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
                  content: SingleChildScrollView(
                    child: ColorPicker(
                      pickerColor: widget.currentColor,
                      hexInputBar: true,
                      paletteType: PaletteType.hsv,
                      portraitOnly: true,
                      enableAlpha: false,
                      displayThumbColor: true,
                      hexInputController: textController,
                      onColorChanged: (color) {
                        widget.callback(color);
                      },
                    ),
                  ),
                );
              },
            );
          },
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black87),
              color: widget.currentColor,
              borderRadius: const BorderRadius.all(Radius.circular(30)),
            ),
          ),
        ),
      ],
    );
  }
}
