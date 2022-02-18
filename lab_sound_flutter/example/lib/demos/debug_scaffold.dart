import 'dart:math';

import 'package:flutter/material.dart';
import 'package:graphview/GraphView.dart';
import 'package:lab_sound_flutter/lab_sound_flutter.dart';
import 'package:lab_sound_flutter_example/demos/debug_graph.dart';

class DebugScaffold extends StatefulWidget {
  final Widget child;
  DebugScaffold({required this.child, Key? key}) : super(key: key);

  @override
  State<DebugScaffold> createState() => _DebugScaffoldState();
}

class _DebugScaffoldState extends State<DebugScaffold> {

  int childFlex = 1;
  int graphGlex = 1;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        children: [
          Flexible(flex: childFlex, child: widget.child),
          Divider(height: 1,),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(onPressed: () {
                setState(() {
                  graphGlex = 1;
                  childFlex = 50;
                });
              }, icon: Icon(Icons.vertical_align_bottom)),
              IconButton(onPressed: () {
                setState(() {
                  graphGlex = 1;
                  childFlex = 1;
                });
              }, icon: Icon(Icons.vertical_align_center)),
              IconButton(onPressed: () {
                setState(() {
                  graphGlex = 50;
                  childFlex = 1;
                });
              }, icon: Icon(Icons.vertical_align_top)),
            ],
          ),
          Divider(height: 1,),
          Flexible(flex: graphGlex, child: DebugGraph())
        ],
      ),
    );
  }
}
