import 'package:flutter/material.dart';

import 'package:hnotes/domain/common_data.dart';
import 'package:hnotes/presentation/components/build_card_widget.dart';
import 'package:hnotes/presentation/components/browser.dart';
import 'package:hnotes/application/blockchain_info/blockchain_info_bloc.dart';

class AboutAppWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    blockchainInfoBloc.fetchNetworkData();

    final ButtonStyle style = ElevatedButton.styleFrom(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    );

    void openGitHub() {
      Navigator.of(context).push(new MaterialPageRoute(builder: (_) {
        return new Browser(title: "BigtoC/hnotes", url: "https://github.com/BigtoC/hnotes");
      }));
    }

    return buildCardWidget(
        context,
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            cardTitle('About App'),
            Container(
              height: 40,
            ),
            cardContentTitle('Developed by'),
            cardContent(context, 'Bigto Chan'),
            Container(
              alignment: Alignment.center,
              child: OutlinedButton.icon(
                icon: Icon(Icons.code),
                label: Text('GITHUB',
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1,
                        color: Colors.grey.shade500)),
                style: style,
                onPressed: openGitHub,
              ),
            ),
            cardContentGap(),
            cardContentTitle('Co-Designer'),
            cardContent(context, 'Rita vv'),
            cardContentGap(),
            cardContentTitle('Made With'),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    FlutterLogo(
                      size: 40,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Flutter',
                        style: TextStyle(fontSize: 24),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Container(
              height: 30,
            ),
            cardContentTitle('Blockchain Platform'),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      "assets/Images/logo/Ethereum-Logo.png",
                      height: 40,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: new FutureBuilder(
                        future: blockchainInfoBloc.fetchNetworkData(),
                        builder: (context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
                          String _networkName = "......";
                          if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          }
                          if (snapshot.hasData) {
                            _networkName = snapshot.data!["text"].toString();
                          }
                          return Text(
                            "Ethereum \n$_networkName",
                            style: TextStyle(fontSize: 22),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: Image.asset(
                "assets/Images/logo/alchemy-logo-blue-gradient.png",
                height: 40,
              ),
            ),
            cardContentGap(),
            cardContentTitle('Version'),
            cardContent(context, "${packageInfo.version}+${packageInfo.buildNumber}"),
            cardContentGap(),
          ],
        ));
  }
}
