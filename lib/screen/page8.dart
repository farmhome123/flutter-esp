import 'package:flutter/material.dart';

class page8_screen extends StatefulWidget {
  const page8_screen({ Key? key }) : super(key: key);

  @override
  _page8_screenState createState() => _page8_screenState();
}

class _page8_screenState extends State<page8_screen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Page8'),
        centerTitle: true,
      ),
      body: SafeArea(child: Container()),
    );
  }
}