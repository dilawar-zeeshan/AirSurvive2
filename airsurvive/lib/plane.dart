import 'package:flutter/material.dart';

class Myplane extends StatelessWidget {
  final planeY;
  final double planeWidth; // normal double value for width.
  final double planeHeight; // out of 2, 2 being the entire height of the screen

  Myplane({this.planeY, required this.planeWidth, required this.planeHeight});

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment(0, (2 * planeY + planeHeight) / (2 - planeHeight)),
        child: Image.asset(
          "assets/images/jah.png",
          width: MediaQuery.of(context).size.height * planeWidth / 1,
          height: MediaQuery.of(context).size.height * 3 / 4 * planeHeight / 2,
          fit: BoxFit.fill,
        ));
  }
}
