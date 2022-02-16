import 'package:flutter/material.dart';

class RefreshWidget extends StatefulWidget {
  const RefreshWidget({required this.child, required this.onRefresh, Key? key}) : super(key: key);
  final Widget child;
  final Future Function() onRefresh;
  @override
  _RefreshWidgetState createState() => _RefreshWidgetState();
}

class _RefreshWidgetState extends State<RefreshWidget> {
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: widget.onRefresh,
      child: widget.child,
    );
  }
}
