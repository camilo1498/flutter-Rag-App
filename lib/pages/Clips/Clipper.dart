import 'dart:ui';
import 'package:flutter/material.dart';

class GetHomeClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height);
    path.quadraticBezierTo(size.width/4, size.height - 40, size.width/2, size.height-20);
    path.quadraticBezierTo(3/4*size.width, size.height, size.width, size.height-30);
    path.lineTo(size.width, 0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip
    return true;

  }
}

class GetClipperSettings extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = new Path();

    path.lineTo(80.0, size.height -300);
    path.quadraticBezierTo(size.width/3,size.height, size.width/1, size.height);
    path.quadraticBezierTo(size.width-(size.width/5), size.height, size.width, size.height-0);
    path.lineTo(size.width, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip
    return true;

  }
}
class GetClipperAccount extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.quadraticBezierTo(1/3*size.width, size.height, size.width, size.height-2);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip
    return true;

  }
}

class GetClipperUS extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = new Path();

    path.lineTo(0.0, size.height -50);
    path.quadraticBezierTo(size.width/5,size.height, size.width/2, size.height);
    path.quadraticBezierTo(size.width-(size.width/5), size.height, size.width, size.height-50);
    path.lineTo(size.width, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip
    return true;

  }
}

class GetClipperAnuncio extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = new Path();

    path.lineTo(0.0, size.height -120);
    path.quadraticBezierTo(size.width/30,size.height, size.width/3, size.height);
    path.quadraticBezierTo(size.width-(size.width/5), size.height, size.width, size.height-0);
    path.lineTo(size.width, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip
    return true;

  }
}

//////////////////////////////////
//login clippers




class GetLoginBlueGray extends CustomPainter{
  @override
  void paint(Canvas canvas, Size size) {
    var rect = Offset.zero & size;
    var gradient = LinearGradient(
      colors: [const Color(0xFF4A4A58), Colors.black],
      begin: FractionalOffset.topCenter,
      end: FractionalOffset.bottomCenter
    );

    var gradient2 = LinearGradient(
        colors: [Colors.red[500], Colors.red[800]],
        begin: FractionalOffset.topCenter,
        end: FractionalOffset.bottomCenter
    );

    var gradient3 = LinearGradient(
        colors: [Colors.black, Colors.black],
        begin: FractionalOffset.topCenter,
        end: FractionalOffset.bottomCenter
    );

    Path path = Path();
    Paint paint = Paint();

    path.lineTo(0, size.height);
    path.cubicTo(size.width -130, 1.5 * size.height / 1.95, 2 * size.width/4, size.height /1.9, size.width, size.height/1.5);
    path.lineTo(size.width, 0);
    path.close();
    paint.color = Colors.red[900];
    canvas.drawPath(path, paint);
//
    //
    path = Path();
    path.lineTo(0, size.height);
    path.cubicTo(size.width -130, 1.5 * size.height / 2, 2 * size.width/4, size.height /2, size.width, size.height/1.6);
    path.lineTo(size.width, 0);
    path.close();
    //paint.color = Colors.red[600];
    paint.shader = gradient2.createShader(rect);
    canvas.drawPath(path, paint);
//
    path =Path();
    path.lineTo(0, size.height-5);
    path.cubicTo(size.width -130, 1.5 * size.height / 2, 2 * size.width/4, size.height /3.9, size.width, size.height/4.4);
    path.lineTo(size.width,0);
    path.close();
    paint.shader = gradient3.createShader(rect);
    canvas.drawPath(path, paint);

//
    path =Path();
    path.lineTo(0, size.height-30);
    path.cubicTo(size.width -130, 1.5 * size.height / 2, 2 * size.width/4, size.height /4, size.width, size.height/4.5);
    path.lineTo(size.width,0);
    path.close();
   // paint.color = Color.fromRGBO(65, 65, 77, 0.8);
    paint.shader = gradient.createShader(rect);
    canvas.drawPath(path, paint);



  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return oldDelegate != this;
  }

}

class GetRegisterBlueGray extends CustomPainter{
  @override
  void paint(Canvas canvas, Size size) {
    var rect = Offset.zero & size;
    var gradient = LinearGradient(
        colors: [const Color(0xFF4A4A58), Colors.black],
        begin: FractionalOffset.topCenter,
        end: FractionalOffset.bottomCenter
    );

    var gradient2 = LinearGradient(
        colors: [Colors.red[500], Colors.red[800]],
        begin: FractionalOffset.topCenter,
        end: FractionalOffset.bottomCenter
    );

    var gradient3 = LinearGradient(
        colors: [Colors.black, Colors.black],
        begin: FractionalOffset.topCenter,
        end: FractionalOffset.bottomCenter
    );

    Path path = Path();
    Paint paint = Paint();

    path.lineTo(0, size.height-105);
    path.cubicTo(size.width -130, 1.5 * size.height / 1.95, 2 * size.width/4.1, size.height /1.6, size.width, size.height/1);
    path.lineTo(size.width, 0);
    path.close();
    paint.color = Colors.red[900];
    canvas.drawPath(path, paint);
//
    //
    path = Path();
    path.lineTo(0, size.height-109);
    path.cubicTo(size.width -130, 1.5 * size.height / 2, 2 * size.width/4, size.height /1.6, size.width, size.height/1.02);
    path.lineTo(size.width, 0);
    path.close();
    //paint.color = Colors.red[600];
    paint.shader = gradient2.createShader(rect);
    canvas.drawPath(path, paint);
//
    path =Path();
    path.lineTo(0, size.height-115);
    path.cubicTo(size.width -130, 1.5 * size.height / 2, 2 * size.width/4, size.height /3.9, size.width, size.height/4.4);
    path.lineTo(size.width,0);
    path.close();
    paint.shader = gradient3.createShader(rect);
    canvas.drawPath(path, paint);

//
    path =Path();
    path.lineTo(0, size.height-120);
    path.cubicTo(size.width -130, 1.5 * size.height / 2, 2 * size.width/4, size.height /4, size.width, size.height/4.5);
    path.lineTo(size.width,0);
    path.close();
    // paint.color = Color.fromRGBO(65, 65, 77, 0.8);
    paint.shader = gradient.createShader(rect);
    canvas.drawPath(path, paint);



  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return oldDelegate != this;
  }

}