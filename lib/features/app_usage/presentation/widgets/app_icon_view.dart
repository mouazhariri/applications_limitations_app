import 'dart:typed_data';

import 'package:flutter/material.dart';

class AppIconView extends StatelessWidget {
  const AppIconView({super.key, required this.iconBytes, required this.fallbackText, this.size = 46});

  final Uint8List? iconBytes;
  final String fallbackText;
  final double size;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(size * 0.24),
      child: Container(
        width: size,
        height: size,
        color: Theme.of(context).colorScheme.primaryContainer,
        child: iconBytes == null
            ? Center(child: Text(fallbackText.isEmpty ? '?' : fallbackText.characters.first.toUpperCase()))
            : Image.memory(iconBytes!, fit: BoxFit.cover, gaplessPlayback: true),
      ),
    );
  }
}
