import 'dart:convert';

import 'package:flutter/material.dart';

class Base64AssetImage extends StatelessWidget {
  final String? base64;
  final double size;

  const Base64AssetImage({super.key, this.base64, this.size = 48});

  @override
  Widget build(BuildContext context) {
    if (base64 == null || base64!.isEmpty) {
      return SizedBox(
        width: size,
        height: size,
        child: const Icon(Icons.devices_other, color: Colors.grey),
      );
    }
    try {
      return ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: Image.memory(
          base64Decode(base64!),
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => const Icon(Icons.devices_other, color: Colors.grey),
        ),
      );
    } catch (_) {
      return const Icon(Icons.devices_other, color: Colors.grey);
    }
  }
}
