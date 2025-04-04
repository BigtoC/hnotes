import "package:intl/intl.dart";
import "package:flutter/material.dart";

import "package:hnotes/presentation/components/build_card_widget.dart";
import "package:hnotes/presentation/components/page_header_widget.dart";
import "package:hnotes/application/blockchain_info/blockchain_info_bloc.dart";

// ignore: must_be_immutable
class BlockchainInfoPage extends StatefulWidget {
  const BlockchainInfoPage({super.key});

  @override
  BlockchainInfoPageState createState() => BlockchainInfoPageState();
}

class BlockchainInfoPageState extends State<BlockchainInfoPage> {
  @override
  void initState() {
    super.initState();
    blockchainInfoBloc.sinkAllBlockchainInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: <Widget>[
          Column(
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
                child: PageHeaderWidget(title: "Blockchain Info"),
              ),
              widgets(),
            ],
          ),
        ],
      ),
    );
  }

  Widget widgets() {
    return Column(
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
    return Container(height: 40);
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
            context,
            blockchainInfoBloc.nodeInfoStream,
            "Chain Name",
            "chainName",
          ),
          buildTitleAndContent(
            context,
            blockchainInfoBloc.nodeInfoStream,
            "Chain Id",
            "chainId",
          ),
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
          cardTitle("Latest Block Info"),
          contentGap(),
          buildTitleAndContent(
            context,
            blockchainInfoBloc.latestBlockStream,
            "Block Number",
            "blockNumber",
          ),
          buildTitleAndContent(
            context,
            blockchainInfoBloc.gasPriceStream,
            "Gas Price",
            "gasPrice",
          ),
          buildTitleAndContent(
            context,
            blockchainInfoBloc.latestBlockStream,
            "Block Time",
            "blockTime",
          ),
        ],
      ),
    );
  }

  Widget handleBuildTimeInfo(String timestamp) {
    String datetime = _convertTime(DateTime.now().millisecondsSinceEpoch);
    return cardContent(context, datetime);
  }

  String _convertTime(int timestamp) {
    String neatDate =
        DateFormat.yMMMd()
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
          cardTitle("Node Info"),
          contentGap(),
          buildTitleAndContent(
            context,
            blockchainInfoBloc.nodeInfoStream,
            "Node Version",
            "version",
          ),
          buildTitleAndContent(
            context,
            blockchainInfoBloc.nodeInfoStream,
            "Go Version",
            "goVersion",
            handleData: extractGoVersion,
          ),
          buildTitleAndContent(
            context,
            blockchainInfoBloc.nodeInfoStream,
            "Cosmos SDK Version",
            "cosmosSdkVersion",
          ),
        ],
      ),
    );
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

  Widget extractGoVersion(String detail) {
    final String goVersion = detail.replaceFirst("go version", "");
    return cardContent(context, goVersion);
  }
}
