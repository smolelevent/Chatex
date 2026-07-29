import 'package:flutter/material.dart';

class CustomAvatar extends StatelessWidget {
  const CustomAvatar({
    super.key,
    required this.imageUrl,
    required this.radius,
  });

  final String? imageUrl;
  final double radius;

  @override
  Widget build(BuildContext context) {
    // Ha van érvényes Supabase URL, akkor betölti (és a Flutter automatikusan cache-eli!)
    if (imageUrl != null && imageUrl!.startsWith('http')) {
      return CircleAvatar(
        radius: radius,
        backgroundImage: NetworkImage(imageUrl!),
        backgroundColor: Colors.transparent,
      );
    }

    // Különben visszaadja a te egyedi Default Avatarodat
    return CircleAvatar(
      radius: radius,
      backgroundColor: Colors.grey[600],
      child: Icon(
        Icons.person,
        size: radius * 1.3, // Az ikon mérete arányosan követi a sugarat TODO: megnézni hogy jó
        color: Colors.white,
      ),
    );
  }
}
