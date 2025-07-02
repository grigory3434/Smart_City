import 'package:flutter/material.dart';
import 'image_generator.dart';

class ThemedImage extends StatelessWidget {
  final String title;
  final String type; // 'report', 'volunteer', 'chat'
  final double? width;
  final double? height;

  const ThemedImage({
    Key? key,
    required this.title,
    required this.type,
    this.width,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case 'report':
        return ImageGenerator.generateReportImage(
          title,
          ImageGenerator.getReportColor(title),
        );
      case 'volunteer':
        return ImageGenerator.generateVolunteerImage(
          title,
          ImageGenerator.getVolunteerColor(title),
        );
      case 'chat':
        return ImageGenerator.generateChatImage(
          title,
          ImageGenerator.getChatColor(title),
        );
      default:
        return Container(
          width: width ?? 400,
          height: height ?? 300,
          color: Colors.grey,
          child: Icon(Icons.image, color: Colors.white, size: 50),
        );
    }
  }
}
