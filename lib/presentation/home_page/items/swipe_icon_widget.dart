import "package:flutter/cupertino.dart";

class SwipeIconWidget extends StatelessWidget {
  final Color color;
  final String text;
  final IconData icon;
  final DismissDirection direction;

  const SwipeIconWidget({
    super.key,
    required this.color,
    required this.text,
    required this.icon,
    required this.direction,
  });

  @override
  Widget build(BuildContext context) {
    late AlignmentDirectional directional;
    if (direction == DismissDirection.startToEnd) {
      directional = AlignmentDirectional.centerStart;
    } else if (direction == DismissDirection.endToStart) {
      directional = AlignmentDirectional.centerEnd;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      alignment: directional,
      color: color,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon),
          Text(text, style: const TextStyle(fontSize: 20)),
        ],
      ),
    );
  }
}
