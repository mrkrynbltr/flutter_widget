import 'package:flutter/material.dart';

class StylishMusicTitle extends StatelessWidget {
  final Color textColor;
  final double fontSize;

  const StylishMusicTitle({
    super.key,
    required this.textColor,
    this.fontSize = 22.0,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'M',
          style: TextStyle(
            color: textColor,
            fontSize: fontSize * 1.2,
            fontWeight: FontWeight.bold,
            fontFamily: 'Roboto',
            shadows: [
              Shadow(
                color: Colors.black26,
                offset: const Offset(1, 1),
                blurRadius: 2,
              ),
            ],
          ),
        ),
        Text(
          'usically',
          style: TextStyle(
            color: textColor,
            fontSize: fontSize,
            fontWeight: FontWeight.w500,
            fontFamily: 'Roboto',
          ),
        ),
        Icon(Icons.music_note, color: textColor, size: fontSize * 0.8),
      ],
    );
  }
}
