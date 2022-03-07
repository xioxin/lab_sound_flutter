
import 'package:flutter/material.dart';
import './debug_graph.dart';

class DebugScaffold extends StatefulWidget {
  final Widget child;
  const DebugScaffold({required this.child, Key? key}) : super(key: key);

  @override
  State<DebugScaffold> createState() => _DebugScaffoldState();
}

class _DebugScaffoldState extends State<DebugScaffold> {
  int childFlex = 1;
  int graphGlex = 1;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        bottom: childFlex == 100,
        left: false,
        right: false,
        top: graphGlex == 100,
        child: Column(
          children: [
            Flexible(flex: childFlex, child: widget.child),
            const Divider(
              height: 1,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                    onPressed: () {
                      setState(() {
                        graphGlex = 1;
                        childFlex = 100;
                      });
                    },
                    icon: const Icon(Icons.vertical_align_bottom)),
                IconButton(
                    onPressed: () {
                      setState(() {
                        graphGlex = 100;
                        childFlex = 100;
                      });
                    },
                    icon: const Icon(Icons.vertical_align_center)),
                IconButton(
                    onPressed: () {
                      setState(() {
                        graphGlex = 100;
                        childFlex = 1;
                      });
                    },
                    icon: const Icon(Icons.vertical_align_top)),
              ],
            ),
            const Divider(
              height: 1,
            ),
            Flexible(flex: graphGlex, child: DebugGraph())
          ],
        ),
      ),
    );
  }
}
