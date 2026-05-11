import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainScreen extends StatelessWidget {
  final Widget child;
  const MainScreen({super.key, required this.child});

  int _getIndex(String location) {
    if (location == '/') return 0;
    if (location == '/chat') return 1;
    if (location == '/add') return 2;
    if (location == '/search') return 3;
    if (location == '/settings') return 4;
    return 0;
  }

  void _onTap(BuildContext context, int index) {
    switch (index) {
      case 0: context.go('/'); break;
      case 1: context.go('/chat'); break;
      case 2: context.go('/add'); break;
      case 3: context.go('/search'); break;
      case 4: context.go('/settings'); break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    final currentIndex = _getIndex(location);

    return Scaffold(
      body: child,
      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(20),
        height: 70,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(40),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              onPressed: () => _onTap(context, 0),
              icon: Icon(Icons.home,
                  color: currentIndex == 0 ? Colors.black : Colors.grey),
            ),
            IconButton(
              onPressed: () => _onTap(context, 1),
              icon: Icon(Icons.chat,
                  color: currentIndex == 1 ? Colors.black : Colors.grey),
            ),
            GestureDetector(
              onTap: () => _onTap(context, 2),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(
                  color: Colors.black,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.add, color: Colors.white),
              ),
            ),
            IconButton(
              onPressed: () => _onTap(context, 3),
              icon: Icon(Icons.search,
                  color: currentIndex == 3 ? Colors.black : Colors.grey),
            ),
            IconButton(
              onPressed: () => _onTap(context, 4),
              icon: Icon(Icons.settings,
                  color: currentIndex == 4 ? Colors.black : Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}