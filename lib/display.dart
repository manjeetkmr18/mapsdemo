import 'package:flutter/material.dart';

class DisplayScreen extends StatefulWidget {
  final String title, descrition;
  const DisplayScreen({Key key, this.title, this.descrition}) : super(key: key);

  @override
  _DisplayScreenState createState() => _DisplayScreenState();
}

class _DisplayScreenState extends State<DisplayScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          child: Container(
            child: Text(widget.descrition),
          ),
        ),
      ),
    );
  }
}
