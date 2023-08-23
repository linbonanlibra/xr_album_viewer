import 'package:flutter/material.dart';

import 'nav_drawer.dart';


void main() {
  runApp(const NavDrawerMaterial());
}

class NavDrawerMaterial extends StatelessWidget {
  const NavDrawerMaterial({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: MainPage());
  }
}

class MainPage extends StatelessWidget{
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("XR App"),
      ),
      body: Semantics(
        container: true,
        child: const Center(
          child: Padding(
            padding: EdgeInsets.all(50.0),
            child: Text("左上角"),
          ),
        ),
      ),
      drawer: const NavDrawer(),
    );
  }
  
}


