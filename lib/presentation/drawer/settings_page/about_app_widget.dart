import "package:flutter/material.dart";

import "package:hnotes/domain/common_data.dart";
import "package:hnotes/domain/theme/theme_model.dart";
import "package:hnotes/presentation/components/browser.dart";
import "package:hnotes/presentation/components/build_card_widget.dart";
import "package:hnotes/application/blockchain_info/blockchain_info_bloc.dart";
import "package:hnotes/infrastructure/local_storage/theme/theme_repository.dart";

class AboutAppWidget extends StatelessWidget {
  const AboutAppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final themeRepository = ThemeRepository();

    final ButtonStyle style = ElevatedButton.styleFrom(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    );

    void openGitHub() {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) {
            return Browser(
              title: "BigtoC/hnotes",
              url: "https://github.com/BigtoC/hnotes",
            );
          },
        ),
      );
    }

    return buildCardWidget(
      context,
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          cardTitle("About App"),
          Container(height: 40),
          cardContentTitle("Developer"),
          cardContent(context, "Bigto vv"),
          Container(
            alignment: Alignment.center,
            child: OutlinedButton.icon(
              icon: Icon(Icons.code),
              label: Text(
                "GITHUB",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  letterSpacing: 1,
                  color: Colors.grey.shade500,
                ),
              ),
              style: style,
              onPressed: openGitHub,
            ),
          ),
          cardContentGap(),
          cardContentTitle("Framework"),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  FlutterLogo(size: 40),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Flutter", style: TextStyle(fontSize: 24)),
                  ),
                ],
              ),
            ),
          ),
          Container(height: 30),
          cardContentTitle("Blockchain"),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    "assets/Images/logo/MANTRA-Gradient.png",
                    height: 40,
                  ),
                ],
              ),
            ),
          ),
          cardContentGap(),
          Container(
            alignment: Alignment.center,
            child: FutureBuilder(
              future: themeRepository.getSavedTheme(),
              builder: (context, AsyncSnapshot<ThemeModel> snapshot) {
                if (snapshot.hasError) {
                  logger.e(snapshot.error);
                  return Container();
                }
                if (snapshot.hasData) {
                  final imagePath =
                      snapshot.data!.brightness == Brightness.light
                          ? "assets/Images/logo/CosmWasm-black.png"
                          : "assets/Images/logo/CosmWasm-white.png";
                  return Image.asset(imagePath, height: 40);
                }
                return Container();
              },
            ),
          ),
          cardContentGap(),
          cardContentTitle("App Version"),
          cardContent(
            context,
            "${packageInfo.version}+${packageInfo.buildNumber}",
          ),
          cardContentGap(),
        ],
      ),
    );
  }
}
