import 'package:flutter/material.dart';

import '../../constants/global_colors.dart';
import '../../constants/text_styles.dart';

class DialogueButton extends StatelessWidget {
  final int choice;
  final String title;
  final VoidCallback? onPressed;

  const DialogueButton({
    super.key,
    required this.choice,
    required this.title,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        elevation: 8,
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              gradient: choice == 1
                  ? const LinearGradient(
                      // begin: Alignment.topCenter,
                      // end: Alignment.bottomCenter,
                      colors: [
                          GlobalColors.mainColor,
                          Colors.blue,
                        ])
                  : const LinearGradient(
                      // begin: Alignment.topCenter,
                      // end: Alignment.bottomCenter,
                      colors: [
                          GlobalColors.extraColor,
                          GlobalColors.secondaryColor,
                        ])),
          child: MaterialButton(
            onPressed: onPressed,
            minWidth: 80,
            height: 42,
            child: Text(
              title,
              style: choice == 1
                  ? TextStyles.alertDialogueMainButtonTextStyle
                  : TextStyles.alertDialogueSecondaryButtonTextStyle,
            ),
          ),
        ),
      ),
    );
  }
}
