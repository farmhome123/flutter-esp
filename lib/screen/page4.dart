import 'package:flutter/material.dart';

class page4_screen extends StatefulWidget {
  const page4_screen({ Key? key }) : super(key: key);

  @override
  _page4_screenState createState() => _page4_screenState();
}

class _page4_screenState extends State<page4_screen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Page4'),
        centerTitle: true,
      ),
      body: SafeArea(child: Container()),
    );
  }
}