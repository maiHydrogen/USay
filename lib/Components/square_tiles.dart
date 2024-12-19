import 'package:flutter/material.dart';

class SquareTile1 extends StatelessWidget {
  final String imagePath;
  const SquareTile1({
    super.key,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: MediaQuery.of(context).size.width*0.3,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.black,)),
      child: ClipRRect(borderRadius: BorderRadius.circular(10),
        child: Image.asset(
          imagePath,
        ),
      ),
    );
  }
}

class SquareTile2 extends StatelessWidget {
  final String imagePath;
  final double height;
  const SquareTile2({super.key, required this.imagePath,required this.height});

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      child: Image.asset(
        imagePath,
        height: height,
      ),
    );
  }
}
