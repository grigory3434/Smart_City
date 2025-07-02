import 'package:flutter/material.dart';

class ImageGenerator {
  static Widget generateReportImage(String title, Color color) {
    return Container(
      width: 400,
      height: 300,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _getReportIcon(title),
              size: 64,
              color: Colors.white,
            ),
            SizedBox(height: 16),
            Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  static Widget generateVolunteerImage(String title, Color color) {
    return Container(
      width: 400,
      height: 300,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _getVolunteerIcon(title),
              size: 64,
              color: Colors.white,
            ),
            SizedBox(height: 16),
            Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  static Widget generateChatImage(String title, Color color) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          title[0].toUpperCase(),
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  static IconData _getReportIcon(String title) {
    if (title.contains('дорог') || title.contains('яма')) {
      return Icons.directions_car;
    } else if (title.contains('фонарь') || title.contains('освещение')) {
      return Icons.lightbulb_outline;
    } else if (title.contains('мусор')) {
      return Icons.delete_outline;
    } else if (title.contains('крыша') || title.contains('протекает')) {
      return Icons.home;
    } else if (title.contains('лифт')) {
      return Icons.elevator;
    } else if (title.contains('отопление') || title.contains('батареи')) {
      return Icons.thermostat;
    } else if (title.contains('площадка') || title.contains('качели')) {
      return Icons.child_care;
    } else if (title.contains('подвал') || title.contains('затоплен')) {
      return Icons.water_drop;
    } else {
      return Icons.report_problem;
    }
  }

  static IconData _getVolunteerIcon(String title) {
    if (title.contains('уборка') || title.contains('парк')) {
      return Icons.cleaning_services;
    } else if (title.contains('патрулирование') ||
        title.contains('безопасность')) {
      return Icons.security;
    } else if (title.contains('пожилым') || title.contains('помощь')) {
      return Icons.volunteer_activism;
    } else if (title.contains('обучение') || title.contains('компьютер')) {
      return Icons.computer;
    } else if (title.contains('деревьев') || title.contains('посадка')) {
      return Icons.eco;
    } else if (title.contains('животных') || title.contains('приют')) {
      return Icons.pets;
    } else if (title.contains('юридическая') ||
        title.contains('консультация')) {
      return Icons.gavel;
    } else if (title.contains('берега') || title.contains('реки')) {
      return Icons.water;
    } else {
      return Icons.people;
    }
  }

  static Color getReportColor(String title) {
    if (title.contains('дорог') || title.contains('яма')) {
      return Colors.orange;
    } else if (title.contains('фонарь') || title.contains('освещение')) {
      return Colors.amber;
    } else if (title.contains('мусор')) {
      return Colors.green;
    } else if (title.contains('крыша') || title.contains('протекает')) {
      return Colors.brown;
    } else if (title.contains('лифт')) {
      return Colors.blueGrey;
    } else if (title.contains('отопление') || title.contains('батареи')) {
      return Colors.deepOrange;
    } else if (title.contains('площадка') || title.contains('качели')) {
      return Colors.red;
    } else if (title.contains('подвал') || title.contains('затоплен')) {
      return Colors.cyan;
    } else {
      return Colors.grey;
    }
  }

  static Color getVolunteerColor(String title) {
    if (title.contains('уборка') || title.contains('парк')) {
      return Colors.green;
    } else if (title.contains('патрулирование') ||
        title.contains('безопасность')) {
      return Colors.blue;
    } else if (title.contains('пожилым') || title.contains('помощь')) {
      return Colors.orange;
    } else if (title.contains('обучение') || title.contains('компьютер')) {
      return Colors.purple;
    } else if (title.contains('деревьев') || title.contains('посадка')) {
      return Colors.green;
    } else if (title.contains('животных') || title.contains('приют')) {
      return Colors.red;
    } else if (title.contains('юридическая') ||
        title.contains('консультация')) {
      return Colors.blueGrey;
    } else if (title.contains('берега') || title.contains('реки')) {
      return Colors.cyan;
    } else {
      return Colors.grey;
    }
  }

  static Color getChatColor(String title) {
    if (title.contains('дом')) {
      return Colors.blue;
    } else if (title.contains('двор')) {
      return Colors.green;
    } else if (title.contains('улица')) {
      return Colors.red;
    } else if (title.contains('безопасность')) {
      return Colors.amber;
    } else if (title.contains('волонтёр')) {
      return Colors.purple;
    } else if (title.contains('подъезд')) {
      return Colors.blueGrey;
    } else if (title.contains('дет') || title.contains('площадка')) {
      return Colors.orange;
    } else if (title.contains('парковка')) {
      return Colors.brown;
    } else {
      return Colors.grey;
    }
  }
}
