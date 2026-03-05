import 'package:farmhouse_vendor/views/home/my_bookings.dart';
import 'package:farmhouse_vendor/views/home/home_screen.dart';
import 'package:farmhouse_vendor/views/home/profile_screen.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

class NavbarScreen extends StatefulWidget {
  const NavbarScreen({super.key});

  @override
  State<NavbarScreen> createState() => _NavbarScreenState();
}

class _NavbarScreenState extends State<NavbarScreen>
    with TickerProviderStateMixin {
  int _selectedIndex = 0;
  late final List<AnimationController> _controllers;
  late final List<Animation<double>> _scaleAnimations;

  final List<Widget> _pages = const [
    HomeScreen(),
    MyBookings(),
    ProfileScreen(),
  ];

  final List<_NavItem> _navItems = const [
    _NavItem(
      icon: Icons.home_outlined,
      activeIcon: Icons.home_rounded,
      label: 'Home',
      color: Color(0xFF6C63FF),
    ),
    _NavItem(
      icon: Icons.event,
      activeIcon: Icons.event,
      label: 'My Bookings',
      color: Color(0xFF43CBFF),
    ),
    _NavItem(
      icon: Icons.person_outline_rounded,
      activeIcon: Icons.person_rounded,
      label: 'Profile',
      color: Color(0xFF43E97B),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      _navItems.length,
      (i) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 300),
      ),
    );
    _scaleAnimations = _controllers
        .map(
          (c) => Tween<double>(
            begin: 1.0,
            end: 1.15,
          ).animate(CurvedAnimation(parent: c, curve: Curves.easeOutBack)),
        )
        .toList();
    _controllers[0].forward();
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  void _onTap(int index) {
    if (index == _selectedIndex) return;
    _controllers[_selectedIndex].reverse();
    setState(() => _selectedIndex = index);
    _controllers[index].forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D1A),
      extendBody: true,
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (child, animation) =>
            FadeTransition(opacity: animation, child: child),
        child: KeyedSubtree(
          key: ValueKey(_selectedIndex),
          child: _pages[_selectedIndex],
        ),
      ),

      // ── Floating Glass Bottom Navigation Bar ────────────────────────────
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(32),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              height: 70,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.08),
                borderRadius: BorderRadius.circular(32),
                border: Border.all(
                  color: Colors.white.withOpacity(0.13),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.35),
                    blurRadius: 30,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(_navItems.length, (i) {
                  final item = _navItems[i];
                  final isActive = _selectedIndex == i;

                  return GestureDetector(
                    onTap: () => _onTap(i),
                    behavior: HitTestBehavior.opaque,
                    child: SizedBox(
                      width: 72,
                      child: AnimatedBuilder(
                        animation: _scaleAnimations[i],
                        builder: (context, child) => Transform.scale(
                          scale: _scaleAnimations[i].value,
                          child: child,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeOutCubic,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: isActive
                                    ? item.color.withOpacity(0.18)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Icon(
                                isActive ? item.activeIcon : item.icon,
                                size: 22,
                                color: isActive
                                    ? item.color
                                    : Colors.white.withOpacity(0.4),
                              ),
                            ),
                            const SizedBox(height: 3),
                            AnimatedDefaultTextStyle(
                              duration: const Duration(milliseconds: 300),
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: isActive
                                    ? FontWeight.w700
                                    : FontWeight.w400,
                                color: isActive
                                    ? item.color
                                    : Colors.white.withOpacity(0.35),
                                letterSpacing: 0.3,
                              ),
                              child: Text(item.label),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
class _NavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final Color color;

  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.color,
  });
}
