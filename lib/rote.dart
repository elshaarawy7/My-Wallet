import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:my_wallet/core/theme/app_color.dart';
import 'package:my_wallet/features/home/presentation/pages/home_page.dart';
import 'package:my_wallet/features/transactions/presentation/pages/transactions_page.dart';

class RotePage extends StatefulWidget {
  const RotePage({super.key});

  static const String routeName = '/rotePage';

  @override
  State<RotePage> createState() => _RotePageState();
}

class _RotePageState extends State<RotePage> {
  int battomIndex = 0;

  // قائمة تحتوي على البيانات (الأيقونة + الاسم)
  final List<Map<String, dynamic>> navItems = [
    {'icon': Icons.home, 'label': 'الرئيسية'},
    {'icon': Icons.swap_horiz_rounded, 'label': 'المعاملات'},
  ];

  final List<Widget> pages = [const HomePage(), const TransactionsPage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[battomIndex],
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.infoColor,
        elevation: 4,
        shape: const CircleBorder(),
        onPressed: () {},
        child: const Icon(Icons.add, size: 30, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      // استخدام الـ builder لتخصيص الأيقونة مع النص
      bottomNavigationBar: AnimatedBottomNavigationBar.builder(
        itemCount: navItems.length,
        tabBuilder: (int index, bool isActive) {
          final color = isActive ? Colors.white : Colors.grey;
          return Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(navItems[index]['icon'] as IconData, size: 24, color: color),
              const SizedBox(height: 4),
              Text(
                navItems[index]['label'] as String,
                style: TextStyle(
                  color: color,
                  fontSize: 12,
                  fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          );
        },
        activeIndex: battomIndex,
        backgroundColor: AppColors.infoColor,
        gapLocation: GapLocation.center,
        notchSmoothness: NotchSmoothness.smoothEdge,
        leftCornerRadius: 20,
        rightCornerRadius: 20,
        onTap: (index) {
          setState(() {
            battomIndex = index;
          });
        },
      ),
    );
  }
}
