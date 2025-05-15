import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:traderwho/core/theme/assets.dart';




class CustomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            Assets.svgsHome,
            colorFilter: const ColorFilter.mode(Colors.grey, BlendMode.srcIn),
          ),
          activeIcon: SvgPicture.asset(
            Assets.svgsHome,
            colorFilter: const ColorFilter.mode(Colors.purple, BlendMode.srcIn),
          ),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            Assets.svgsDetails,
            colorFilter: const ColorFilter.mode(Colors.grey, BlendMode.srcIn),
          ),
          activeIcon: SvgPicture.asset(
            Assets.svgsDetails,
            colorFilter: const ColorFilter.mode(Colors.purple, BlendMode.srcIn),
          ),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            Assets.svgsChat,
            colorFilter: const ColorFilter.mode(Colors.grey, BlendMode.srcIn),
          ),
          activeIcon: SvgPicture.asset(
            Assets.svgsChat,
            colorFilter: const ColorFilter.mode(Colors.purple, BlendMode.srcIn),
          ),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            Assets.svgsProfile,
            colorFilter: const ColorFilter.mode(Colors.grey, BlendMode.srcIn),
          ),
          activeIcon: SvgPicture.asset(
            Assets.svgsProfile,
            colorFilter: const ColorFilter.mode(Colors.purple, BlendMode.srcIn),
          ),
          label: '',
        ),
      ],
      currentIndex: currentIndex,
      selectedItemColor: Colors.purple,
      unselectedItemColor: Colors.grey,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
    );
  }
}