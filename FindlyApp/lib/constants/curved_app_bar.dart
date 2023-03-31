import 'package:findly_app/constants/constants.dart';
import 'package:flutter/material.dart';

class CurvedAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CurvedAppBar({
    super.key,
    this.leading,
    this.title,
    this.actions,
    this.bottom,
  });

  final Widget? leading, title;
  final List<Widget>? actions;
  final PreferredSizeWidget? bottom;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      leading: leading,
      title: title,
      actions: actions,
      flexibleSpace: CustomPaint(
        size: Size.infinite,
        painter: _AppBarPainter(),
        // child: child,
      ),
      bottom: bottom,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(
        kToolbarHeight + (WidgetsBinding.instance.window.physicalSize.height * 0.025),
      );
}

class _AppBarPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var rect = Offset.zero & size;
    Paint paint = Paint();
    Path path = Path();
    paint.shader = const LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [
        primaryColor,
        secondaryColor,
      ],
    ).createShader(rect);
    path.lineTo(0, size.height - size.height / 8);
    path.conicTo(
      size.width / 1.2,
      size.height,
      size.width,
      size.height - size.height / 8,
      9,
    );
    path.lineTo(size.width, 0);
    canvas.drawShadow(path, primaryColor, 4, false);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
