import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BeStats extends StatelessWidget {
  final String name;
  final Icon icon;
  final String value;
  final List<Color> colors;

  const BeStats({Key? key, required this.name, required this.icon, required this.value, required this.colors}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 160,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: colors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: const <BoxShadow>[
            BoxShadow(
              color: Colors.grey,
              offset: Offset(0, 0),
              blurRadius: 5.0,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                name,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(fontSize: 20, color: Colors.white, fontWeight: FontWeight.normal),
              ),
              Text(
                value,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(fontSize: 25, color: Colors.white, fontWeight: FontWeight.normal),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
