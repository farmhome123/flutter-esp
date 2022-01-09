import 'package:flutter/material.dart';

class page10_screen extends StatefulWidget {
  const page10_screen({Key? key}) : super(key: key);

  @override
  _page10_screenState createState() => _page10_screenState();
}

class _page10_screenState extends State<page10_screen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Page10'),
        centerTitle: true,
      ),
      body: SafeArea(child: Container()),
    );
  }
}
