import 'package:flutter/material.dart';
import 'package:recipe_advisor_app/widgets/custom_app_bar.dart';

import 'package:recipe_advisor_app/widgets/custom_bottom_navbar.dart';

import 'package:recipe_advisor_app/screens/home_screen_alt.dart';
import 'package:recipe_advisor_app/screens/cookbook_screen.dart';
import 'package:recipe_advisor_app/screens/add_recipe_screen.dart';
import 'package:recipe_advisor_app/screens/chefs_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    const HomeScreenAlt(),
    const CookbookScreen(),
    const AddRecipeScreen(),
    const ChefsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
