import 'package:flutter/material.dart';

import '../../constants/global_colors.dart';
import '../../constants/text_styles.dart';

class WideButton extends StatelessWidget {
  final int choice;
  final String title;
  final VoidCallback onPressed;
  final double? width;

  const WideButton({
    super.key,
    required this.choice,
    required this.title,
    required this.onPressed,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 8,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: choice == 1
                ? const LinearGradient(
                    colors: [
                      GlobalColors.mainColor,
                      Colors.blue,
                    ],
                  )
                : const LinearGradient(
                    colors: [
                      GlobalColors.extraColor,
                      GlobalColors.secondaryColor,
                    ],
                  ),
          ),
          child: MaterialButton(
            onPressed: onPressed,
            minWidth: width,
            height: 48,
            child: Text(
              title,
              style: choice == 1 ? TextStyles.buttonTextStyle : TextStyles.secondButtonTextStyle,
            ),
          ),
        ),
      ),
    );
  }
}
