import 'package:flutter/material.dart';

class TechnicianHomeStat {
  final String title;
  final String value;
  final String subtitle;
  final Color color;

  const TechnicianHomeStat({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.color,
  });
}

class TechnicianJobItem {
  final String id;
  final String customerName;
  final String serviceName;
  final String time;
  final String location;
  final String amount;
  final bool isUrgent;

  const TechnicianJobItem({
    required this.id,
    required this.customerName,
    required this.serviceName,
    required this.time,
    required this.location,
    required this.amount,
    this.isUrgent = false,
  });
}

class TechnicianQuickAction {
  final String id;
  final String title;
  final IconData icon;
  final Color color;

  const TechnicianQuickAction({
    required this.id,
    required this.title,
    required this.icon,
    required this.color,
  });
}
