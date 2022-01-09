import 'package:flutter/material.dart';

class page9_screen extends StatefulWidget {
  const page9_screen({Key? key}) : super(key: key);

  @override
  _page9_screenState createState() => _page9_screenState();
}

class _page9_screenState extends State<page9_screen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Page9'),
        centerTitle: true,
      ),
      body: SafeArea(child: Container()),
    );
  }
}
