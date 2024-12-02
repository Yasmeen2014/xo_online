// ignore_for_file: library_private_types_in_public_api

import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class GlitchText extends StatefulWidget {
  final String text;
  final double fontSize;
  final int glitchFrequency; // Time interval for glitching in milliseconds
  final TextStyle textStyle; // Custom text style
  final String
      customCharacterSet; // Custom set of characters for the glitch effect

  const GlitchText({
    Key? key,
    required this.text,
    required this.fontSize,
    required this.glitchFrequency,
    required this.textStyle,
    required this.customCharacterSet,
  }) : super(key: key);

  @override
  _GlitchTextState createState() => _GlitchTextState();
}

class _GlitchTextState extends State<GlitchText> {
  late List<String> _letters;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _letters = List.generate(widget.text.length, (index) => widget.text[index]);
    _startGlitchEffect();
  }

  void _startGlitchEffect() {
    _timer = Timer.periodic(
      Duration(milliseconds: widget.glitchFrequency),
      (timer) {
        setState(() {
          for (int i = 0; i < _letters.length; i++) {
            if (Random().nextDouble() < 0.3) {
              // 30% chance to change a character
              _letters[i] = _getRandomCharacter();
            }
          }
        });
      },
    );
  }

  String _getRandomCharacter() {
    // Get a random character from the custom character set
    return widget
        .customCharacterSet[Random().nextInt(widget.customCharacterSet.length)];
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _letters.join(),
      style: widget.textStyle.copyWith(
        fontSize: widget.fontSize,
      ),
    );
  }
}
