import 'package:flutter/material.dart';

//Reusable button widget code across the screens
class MyButton extends StatelessWidget {
  const MyButton({
    super.key,
    required this.color,
    required this.title,
    this.onPressed,
  });

  final Color color;
  final String title;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Material(
        elevation: onPressed == null ? 0 : 5,
        color: color.withOpacity(
          onPressed == null ? 0.5 : 1,
        ),
        borderRadius: BorderRadius.circular(15),
        child: MaterialButton(
          onPressed: onPressed,
          minWidth: double.infinity,
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
