import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

import 'package:hnotes/util/common_data.dart';
import 'package:hnotes/components/build_card_widget.dart';
import 'package:hnotes/drawer/blockchain_info/blockchain_info_bloc.dart';

// ignore: must_be_immutable
class ChainInfoPage extends StatefulWidget {
  @override
  _ChainInfoPageState createState() => _ChainInfoPageState();
}

class _ChainInfoPageState extends State<ChainInfoPage> {

  @override
  void initState() {
    super.initState();
    blockchainInfoBloc.fetchBlockchainInfo();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: <Widget>[
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    handleBack();
                  },
                  child: Container(
                    padding: const EdgeInsets.only(top: 24, left: 24, right: 24),
                    child: Icon(Icons.arrow_back),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16, top: 36, right: 24),
                  child: buildHeaderWidget('Blockchain Info'),
                ),
                buildNetworkStatus(),
                buildLatestBlockInfo(),
                buildAccountInfo(),
              ],
            )
          )
        ],
      ),
    );
  }

  void handleBack() {
    Navigator.pop(context);
  }

  Widget buildNetworkStatus() {
    return buildCardWidget(
      context,
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          cardTitle("Blockchain Network"),
          Container(
            height: 40,
          ),
          buildTitleAndContent(
              context,
              blockchainInfoBloc.currentNetwork,
              "Current Network", "text"
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
          cardTitle('Latest Block Info'),
          Container(
            height: 40,
          ),
          buildTitleAndContent(
              context,
              blockchainInfoBloc.latestBlockNumberData,
              "Latest Block Number", "number"
          ),
          buildTitleAndContent(
              context,
              blockchainInfoBloc.currentGasPriceData,
              "CurrentGas Price", "number"
          ),
          buildTitleAndContent(
              context,
              blockchainInfoBloc.currentGasPriceData,
              "Last Updated", "timestamp",
              handleData: handleBuildTimeInfo
          ),
        ],
      )
    );
  }

  Widget handleBuildTimeInfo(String timestamp) {
    String datetime = _convertTime(DateTime.now().millisecondsSinceEpoch);
    return cardContent(context, datetime);
  }

  String _convertTime(int timestamp) {
    String neatDate = DateFormat.yMMMd().add_jm().format(
        DateTime.fromMillisecondsSinceEpoch(timestamp)
    ).toString();
    return neatDate;
  }

  Widget buildAccountInfo() {
    return buildCardWidget(
      context,
      Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        cardTitle('Account Info'),
        Container(
          height: 40,
        ),
        cardContentTitle("Account Name"),
        cardContent(context, queryAccountName),
        cardContentGap(),
        buildTitleAndContent(
          context,
          blockchainInfoBloc.accountData,
          "Gas Balance", "balance"
        ),
        buildTitleAndContent(
          context,
          blockchainInfoBloc.accountData,
          "Account Address", "id"
        ),
      ],
    ));
  }
}
