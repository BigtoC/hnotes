import "package:flutter/material.dart";
import "package:hnotes/presentation/home_page/base/dapp_details_page.dart";

import "package:hnotes/presentation/theme.dart";
import "package:hnotes/presentation/home_page/base/swipe_widget.dart";
import "package:hnotes/presentation/home_page/items/swipe_icon_widget.dart";

class OneDappWidget extends StatelessWidget {
  final String dAppName;
  final String cardContent;
  final Widget dAppDetailsWidget;

  const OneDappWidget({
    super.key,
    required this.dAppName,
    required this.cardContent,
    required this.dAppDetailsWidget,
  });

  @override
  Widget build(BuildContext context) {
    final Radius allBorderRadius = Radius.circular(20);
    // Pick random color for shadow
    int randomNumber = dAppName.hashCode;
    Color colors = colorList.elementAt(randomNumber % colorList.length);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(allBorderRadius),
        boxShadow: [buildBoxShadow(context, colors)],
      ),
      padding: EdgeInsets.all(10),
      child: Material(
        borderRadius: BorderRadius.all(allBorderRadius),
        clipBehavior: Clip.antiAlias,
        color: Theme.of(context).dialogTheme.backgroundColor,
        child: InkWell(
          borderRadius: BorderRadius.all(allBorderRadius),
          splashColor: colors.withAlpha(20),
          highlightColor: colors.withAlpha(10),
          child: SwipeWidget(
            dAppName: dAppName,
            cardContent: cardContent,
            allBorderRadius: allBorderRadius,
            leftBackground: SwipeIconWidget(
              color: Colors.green,
              icon: Icons.content_paste_go,
              text: "Details",
              direction: DismissDirection.startToEnd,
            ),
            rightBackground: SwipeIconWidget(
              color: Colors.green,
              icon: Icons.content_paste_go,
              text: "Details",
              direction: DismissDirection.endToStart,
            ),
            confirmStartToEnd: confirmStartToEnd,
            confirmEndToStart: confirmEndToStart,
          ),
        ),
      ),
    );
  }

  // Common method to navigate to details page
  Future<bool?> navigateToDetailsPage(BuildContext context) {
    Navigator.of(context).push(
      newPageRoute(
        DAppDetailsPage(
          dAppName: dAppName,
          dAppDetailsWidget: dAppDetailsWidget,
        ),
      ),
    );
    // Return null so the item won't be dismissed
    return Future.value(null);
  }

  confirmStartToEnd(BuildContext context) {
    return navigateToDetailsPage(context);
  }

  confirmEndToStart(BuildContext context) async {
    return navigateToDetailsPage(context);
  }

  Route newPageRoute(Widget newPage) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => newPage,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(-1, 0.0);
        const end = Offset.zero;
        const curve = Curves.ease;
        var tween = Tween(
          begin: begin,
          end: end,
        ).chain(CurveTween(curve: curve));

        return SlideTransition(position: animation.drive(tween), child: child);
      },
      transitionDuration: const Duration(milliseconds: 500),
    );
  }

  BoxShadow buildBoxShadow(BuildContext context, Color color) {
    return BoxShadow(
      color: color.withAlpha(31),
      blurRadius: 16,
      offset: Offset(0, 8),
    );
  }
}
