import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:squadonsite/presentation/screens/technician_home_screen/model/technician_home_model.dart';

class TechnicianHomeController extends GetxController {
  final RxBool isAvailable = true.obs;
  final RxInt selectedQuickActionIndex = 0.obs;

  List<TechnicianHomeStat> get stats => [
        const TechnicianHomeStat(
          title: 'Jobs today',
          value: '12',
          subtitle: '+3 from yesterday',
          color: Color(0xFF2E7DFF),
        ),
        const TechnicianHomeStat(
          title: 'Pending',
          value: '04',
          subtitle: 'Needs attention',
          color: Color(0xFFFFB000),
        ),
        const TechnicianHomeStat(
          title: 'Earnings',
          value: '₹14.2k',
          subtitle: 'This week',
          color: Color(0xFF2CB67D),
        ),
        const TechnicianHomeStat(
          title: 'Rating',
          value: '4.9',
          subtitle: 'Customer score',
          color: Color(0xFF8E5CF6),
        ),
      ];

  List<TechnicianQuickAction> get quickActions => [
        const TechnicianQuickAction(
          id: 'jobs',
          title: 'My Jobs',
          icon: Icons.assignment_rounded,
          color: Color(0xFF2E7DFF),
        ),
        const TechnicianQuickAction(
          id: 'earnings',
          title: 'Earnings',
          icon: Icons.account_balance_wallet_rounded,
          color: Color(0xFF2CB67D),
        ),
        const TechnicianQuickAction(
          id: 'chat',
          title: 'Support',
          icon: Icons.chat_bubble_rounded,
          color: Color(0xFF8E5CF6),
        ),
        const TechnicianQuickAction(
          id: 'profile',
          title: 'Profile',
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
