import 'package:flutter/material.dart';

class page6_screen extends StatefulWidget {
  const page6_screen({Key? key}) : super(key: key);

  @override
  _page6_screenState createState() => _page6_screenState();
}

class _page6_screenState extends State<page6_screen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Page6'),
        centerTitle: true,
      ),
      body: SafeArea(child: Container()),
    );
  }
}
