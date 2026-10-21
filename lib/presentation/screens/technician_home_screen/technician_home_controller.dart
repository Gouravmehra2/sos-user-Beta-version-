import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:squadonsite/presentation/screens/technician_home_screen/model/technician_home_model.dart';

class TechnicianHomeController extends GetxController {
  final RxBool isAvailable = true.obs;
  final RxInt selectedQuickActionIndex = 0.obs;

  List<TechnicianHomeStat> get stats => [
    TechnicianHomeStat(
      title: "Jobs today".tr,
      value: '12',
      subtitle: "+3 from yesterday".tr,
      color: Color(0xFF2E7DFF),
    ),
    TechnicianHomeStat(
      title: "Pending".tr,
      value: '04',
      subtitle: "Needs attention".tr,
      color: Color(0xFFFFB000),
    ),
    TechnicianHomeStat(
      title: "Earnings".tr,
      value: '₹14.2k',
      subtitle: "This week".tr,
      color: Color(0xFF2CB67D),
    ),
    TechnicianHomeStat(
      title: "Rating".tr,
      value: '4.9',
      subtitle: "Customer score".tr,
      color: Color(0xFF8E5CF6),
    ),
  ];

  List<TechnicianQuickAction> get quickActions => [
    TechnicianQuickAction(
      id: 'jobs',
      title: "My Jobs".tr,
      icon: Icons.assignment_rounded,
      color: Color(0xFF2E7DFF),
    ),
    TechnicianQuickAction(
      id: 'earnings',
      title: "Earnings".tr,
      icon: Icons.account_balance_wallet_rounded,
      color: Color(0xFF2CB67D),
    ),
    TechnicianQuickAction(
      id: 'chat',
      title: "profile_quick_support".tr,
      icon: Icons.chat_bubble_rounded,
      color: Color(0xFF8E5CF6),
    ),
    TechnicianQuickAction(
      id: 'profile',
      title: "nav_profile".tr,
      icon: Icons.person_rounded,
      color: Color(0xFFFFB000),
    ),
  ];

  List<TechnicianJobItem> get todayJobs => [
    const TechnicianJobItem(
      id: 'JD-1042',
      customerName: 'Ritika Sharma',
      serviceName: 'AC Repair',
      time: '10:30 AM',
      location: 'Sector 15, Noida',
      amount: '₹1,200',
      isUrgent: true,
    ),
    const TechnicianJobItem(
      id: 'JD-1044',
      customerName: 'Vikas Kumar',
      serviceName: 'TV Installation',
      time: '12:45 PM',
      location: 'Indirapuram',
      amount: '₹900',
    ),
    const TechnicianJobItem(
      id: 'JD-1048',
      customerName: 'Neha Verma',
      serviceName: 'Plumbing Service',
      time: '03:15 PM',
      location: 'Greater Kailash',
      amount: '₹1,450',
    ),
  ];

  void toggleAvailability() {
    isAvailable.value = !isAvailable.value;
  }

  void onQuickActionTap(int index) {
    selectedQuickActionIndex.value = index;
  }
}
