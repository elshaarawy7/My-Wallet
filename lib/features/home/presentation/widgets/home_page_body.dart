import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class HomePageBody extends StatelessWidget {
  const HomePageBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Gap(50),
            ) , 
            
          ]
            
          
        ),
      ),
    );
  }
}