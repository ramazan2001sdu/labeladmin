import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingPicker extends StatefulWidget {
  const LoadingPicker({Key? key, required this.selectedType, required this.onChange}) : super(key: key);
  final int selectedType;
  final Function onChange;
  @override
  State<LoadingPicker> createState() => _LoadingPickerState();
}

class _LoadingPickerState extends State<LoadingPicker> {
  int currentType = 1;

  @override
  void initState() {
    // TODO: implement initState
    currentType = widget.selectedType;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: rows(),
    );
  }

  List<Widget> rows() {
    List<Widget> spinRows = [];
    for (var i = 1; i <= 11; i++) {
      if (i == currentType) {
        spinRows.add(addRow(i, true));
      } else {
        spinRows.add(addRow(i, false));
      }
    }
    return spinRows;
  }

  Widget addRow(int type, bool selected) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Column(
          children: [
            Checkbox(
              value: selected,
              onChanged: (newValue) {
                setState(() {
                  currentType = type;
                  widget.onChange(currentType);
                });
              },
              activeColor: Colors.black,
              checkColor: Colors.white,
            ),
            const SizedBox(
              height: 8,
            ),
            spinKit(type),
          ],
        ),
        const SizedBox(
          width: 30,
        ),
      ],
    );
  }

  Widget spinKit(int type) {
    if (type == 1) {
      return const SpinKitRotatingPlain(
        color: Colors.black,
        size: 20,
      );
    } else if (type == 2) {
      return const SpinKitDoubleBounce(
        color: Colors.black,
        size: 20,
      );
    } else if (type == 3) {
      return const SpinKitWave(
        color: Colors.black,
        size: 20,
      );
    } else if (type == 4) {
      return const SpinKitFadingFour(
        color: Colors.black,
        size: 20,
      );
    } else if (type == 5) {
      return const SpinKitFadingCube(
        color: Colors.black,
        size: 20,
      );
    } else if (type == 6) {
      return const SpinKitSpinningLines(
        color: Colors.black,
        size: 20,
      );
    } else if (type == 7) {
      return const SpinKitFadingCircle(
        color: Colors.black,
        size: 20,
      );
    } else if (type == 8) {
      return const SpinKitPulse(
        color: Colors.black,
        size: 20,
      );
    } else if (type == 9) {
      return const SpinKitThreeBounce(
        color: Colors.black,
        size: 20,
      );
    } else if (type == 10) {
      return const SpinKitChasingDots(
        color: Colors.black,
        size: 20,
      );
    } else if (type == 11) {
      return const SpinKitRing(
        color: Colors.black,
        size: 20,
      );
    }

    return Container();
  }
}
