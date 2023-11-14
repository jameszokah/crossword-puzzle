import 'package:flutter/material.dart';

//Add this CustomPaint widget to the Widget Tree
// CustomPaint(
//     size: Size(WIDTH, (WIDTH*1).toDouble()), //You can Replace [WIDTH] with your desired width for Custom Paint and height will be calculated automatically
//     painter: RPSCustomPainter(),
// )

//Copy this CustomPainter code to the Bottom of the File
class RPSCustomPainter extends CustomPainter {
  Color? color;
  Color? colorFill;
  RPSCustomPainter({this.color, this.colorFill});
  @override
  void paint(Canvas canvas, Size size) {
    Path path = Path();
    path.moveTo(size.width * 0.2500000, size.height * 0.6347833);
    path.lineTo(size.width * 0.5000000, size.height * 0.7736708);
    path.lineTo(size.width * 0.7500000, size.height * 0.6347833);
    path.lineTo(size.width * 0.7500000, size.height * 0.3652171);
    path.lineTo(size.width * 0.5000000, size.height * 0.2263283);
    path.lineTo(size.width * 0.2500000, size.height * 0.3652171);
    path.lineTo(size.width * 0.2500000, size.height * 0.6347833);
    path.close();
    path.moveTo(size.width * 0.5000000, size.height * 0.08333333);
    path.lineTo(size.width * 0.1250000, size.height * 0.2916667);
    path.lineTo(size.width * 0.1250000, size.height * 0.7083333);
    path.lineTo(size.width * 0.5000000, size.height * 0.9166667);
    path.lineTo(size.width * 0.8750000, size.height * 0.7083333);
    path.lineTo(size.width * 0.8750000, size.height * 0.2916667);
    path.lineTo(size.width * 0.5000000, size.height * 0.08333333);
    path.close();

    Paint paintFill = Paint()..style = PaintingStyle.stroke;
    paintFill.color = color!;
    // paintFill.style = PaintingStyle.fill;
    // paintFill.color = colorFill!;

    canvas.drawPath(path, paintFill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
