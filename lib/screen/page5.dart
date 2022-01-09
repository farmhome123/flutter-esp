import 'package:flutter/material.dart';

class page5_screen extends StatefulWidget {
  const page5_screen({Key? key}) : super(key: key);

  @override
  _page5_screenState createState() => _page5_screenState();
}

class _page5_screenState extends State<page5_screen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Page5'),
        centerTitle: true,
      ),
      body: SafeArea(child: Container()),
    );
  }
}
