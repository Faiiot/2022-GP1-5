import 'package:flutter/material.dart';

class MyButton2 extends StatelessWidget {
  MyButton2({
    required this.color,
    required this.title,
    required this.onPressed,
  });

  final Color color;
  final String title;
  final VoidCallback onPressed;
 // final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Material(
        elevation: 5,
        color: color,
        borderRadius: BorderRadius.circular(15),
        child: MaterialButton(
          onPressed:onPressed,
          minWidth: 400,
          height: 100,
          child: Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 25,
                fontWeight: FontWeight.bold
            ),
          ),
        ),
      ),
    );
  }
}