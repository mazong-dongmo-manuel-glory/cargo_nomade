import 'package:cargo_nomade/widgets/bottom_nav.dart';
import 'package:flutter/material.dart';

class ScaffoldWithBottomNav extends StatelessWidget {
  const ScaffoldWithBottomNav({super.key, required this.content});
  final Widget content;

  @override
  Widget build(BuildContext context) {
    return
       Scaffold(
         appBar: AppBar(
           backgroundColor: Colors.white,
           toolbarHeight: 10,
           elevation: 0,
           shadowColor: Colors.transparent,
         ),
        backgroundColor: Colors.white,
        body: content,
        bottomNavigationBar: buildBottomNavBar(context),

    );
  }
}