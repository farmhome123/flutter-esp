import 'package:flutter/material.dart';

class page7_screen extends StatefulWidget {
  const page7_screen({ Key? key }) : super(key: key);

  @override
  _page7_screenState createState() => _page7_screenState();
}

class _page7_screenState extends State<page7_screen> {
  @override
  Widget build(BuildContext context) {
     return Scaffold(
      appBar: AppBar(
        title: Text('Page7'),
        centerTitle: true,
      ),
      body: SafeArea(child: Container()),
    );
  }
}