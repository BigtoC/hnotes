import 'package:flutter/material.dart';

import 'package:hnotes/presentation/theme.dart';


// ignore: must_be_immutable
class FlagToggleWidget extends StatefulWidget {
  late bool isFlagOn;
  late Function() toggleFlagOnOff;

  FlagToggleWidget({required bool isFlagOn, required Function() toggleFlagOnOff}) {
    this.isFlagOn = isFlagOn;
    this.toggleFlagOnOff = toggleFlagOnOff;
  }

  @override
  State<StatefulWidget> createState() => _FlagToggleWidget();
}


class _FlagToggleWidget extends State<FlagToggleWidget> {

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.toggleFlagOnOff,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 160),
        height: 50,
        width: 50,
        curve: Curves.slowMiddle,
        child: Icon(
          widget.isFlagOn ? Icons.flag : Icons.outlined_flag,
          color: widget.isFlagOn ? Colors.white : Colors.grey.shade300,
        ),
        decoration: BoxDecoration(
            color: widget.isFlagOn ? btnColor : Colors.transparent,
            border: Border.all(
              width: widget.isFlagOn ? 2 : 1,
              color:
              widget.isFlagOn ? btnColor : Colors.grey.shade300,
            ),
            borderRadius: BorderRadius.all(Radius.circular(16))),
      ),
    );
  }
}
