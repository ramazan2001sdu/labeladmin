import 'package:flutter/material.dart';

class BeTextField extends StatelessWidget {
  final String text;
  final Function callback;
  final String title;
  final String subtitle;

  BeTextField({Key? key, required this.title, required this.subtitle, required this.text, required this.callback}) : super(key: key);

  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    controller.text = text;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.bodyText2,
        ),
        const SizedBox(
          height: 15,
        ),
        Container(
          width: 300,
          color: Colors.white,
          child: TextField(
            obscureText: false,
            controller: controller,
            onChanged: (text) {
              callback(text);
            },
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Theme.of(context).secondaryHeaderColor, width: 1.0),
              ),
              labelText: subtitle,
            ),
          ),
        ),
      ],
    );
  }
}
