import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  const MyButton({
    super.key,
    required this.color,
    required this.title,
    required this.onPressed,
  });

  final Color color;
  final String title;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Material(
        elevation: 5,
        color: color,
        borderRadius: BorderRadius.circular(15),
        child: MaterialButton(
          onPressed: onPressed,
          minWidth: 200,
          height: 42,
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
        ),
      ),
    );
  }
}
