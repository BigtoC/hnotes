import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

import 'package:hnotes/presentation/components/build_card_widget.dart';
import 'package:hnotes/presentation/components/page_header_widget.dart';
import 'package:hnotes/application/blockchain_info/blockchain_info_bloc.dart';

// ignore: must_be_immutable
class BlockchainInfoPage extends StatefulWidget {
  @override
  _BlockchainInfoPageState createState() => _BlockchainInfoPageState();
}

class _BlockchainInfoPageState extends State<BlockchainInfoPage> {
  @override
  void initState() {
    super.initState();
    blockchainInfoBloc.fetchAllBlockchainInfo();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new ListView(
          physics: BouncingScrollPhysics(),
          children: <Widget>[
            new Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: handleBack,
                      child: Container(
                        padding: const EdgeInsets.only(top: 24, left: 24, right: 24),
                        child: const Icon(Icons.arrow_back),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 16, top: 36, right: 24),
                      child: new PageHeaderWidget(title: "Blockchain Info"),
                    ),
                    widgets(),
                  ],
                )
            )
          ]
      ),
    );
  }

  Widget widgets() {
    return new Column(
      children: [
        buildNetworkStatus(),
        buildLatestBlockInfo(),
        buildNodeClientInfo(),
      ],
    );
  }

  void handleBack() {
    Navigator.pop(context);
  }

  Widget contentGap() {
    return Container(
      height: 40,
    );
  }

  Widget buildNetworkStatus() {
    return buildCardWidget(
      context,
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          cardTitle("Blockchain Network"),
          contentGap(),
          buildTitleAndContent(
              context, blockchainInfoBloc.currentNetworkData, "Current Network", "text"),
          buildTitleAndContent(context, blockchainInfoBloc.chainIdData, "Chain Id", "number"),
        ],
      ),
    );
  }

  Widget buildLatestBlockInfo() {
    return buildCardWidget(
        context,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            cardTitle('Latest Block Info'),
            contentGap(),
            buildTitleAndContent(
                context, blockchainInfoBloc.latestBlockNumberData, "Block Number", "number"),
            buildTitleAndContent(
                context, blockchainInfoBloc.currentGasPriceData, "Gas Price (wei)", "number"),
            buildTitleAndContent(
                context, blockchainInfoBloc.currentGasPriceData, "Last Updated", "timestamp",
                handleData: handleBuildTimeInfo),
          ],
        ));
  }

  Widget handleBuildTimeInfo(String timestamp) {
    String datetime = _convertTime(DateTime.now().millisecondsSinceEpoch);
    return cardContent(context, datetime);
  }

  String _convertTime(int timestamp) {
    String neatDate = DateFormat.yMMMd()
        .add_jm()
        .format(DateTime.fromMillisecondsSinceEpoch(timestamp))
        .toString();
    return neatDate;
  }

  Widget buildNodeClientInfo() {
    return buildCardWidget(
        context,
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            cardTitle('Node Client Info'),
            contentGap(),
            buildTitleAndContent(
                context, blockchainInfoBloc.nodeClientVersionData, "Client Name", "text",
                handleData: extractClientName),
            buildTitleAndContent(
                context, blockchainInfoBloc.nodeClientVersionData, "Client Version", "text",
                handleData: extractClientVersion),
            buildTitleAndContent(
                context, blockchainInfoBloc.nodeClientVersionData, "Client Environment", "text",
                handleData: extractClientEnvironment),
          ],
        ));
  }

  Widget extractClientName(String detail) {
    final String clientName = detail.split("/")[0];
    return cardContent(context, clientName);
  }

  Widget extractClientVersion(String detail) {
    final String fullClientVersion = detail.split("/")[1];
    final String clientVersion =
        "${fullClientVersion.split("-")[0]}-${fullClientVersion.split("-")[1]}";
    return cardContent(context, clientVersion);
  }

  Widget extractClientEnvironment(String detail) {
    final String clientEnvironment = "${detail.split("/")[2]} / ${detail.split("/")[3]}";
    return cardContent(context, clientEnvironment);
  }
}
