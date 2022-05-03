import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:hnotes/util/common_data.dart';
import 'package:hnotes/components/build_card_widget.dart';
import 'package:hnotes/drawer/chain_info/chain_info_bloc.dart';

// ignore: must_be_immutable
class ChainInfoPage extends StatefulWidget {
  @override
  _ChainInfoPageState createState() => _ChainInfoPageState();
}

class _ChainInfoPageState extends State<ChainInfoPage> {

  @override
  void initState() {
    super.initState();
    chainInfoBloc.fetchChainInfo();
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
          cardContentTitle('Network Status'),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
              child: chainInfoBloc.blockHeaderData.isEmpty != null
                ? cardContent(context, "Normal", Colors.greenAccent)
                : cardContent(context, "Error", Colors.red)
            )
          )
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
            chainInfoBloc.blockHeaderData,
            "Block Height", "number", null
          ),
          buildTitleAndContent(
            context,
            chainInfoBloc.blockHeaderData,
            "Gas Used", "gasUsed", null
          ),
          buildTitleAndContent(
            context,
            chainInfoBloc.blockHeaderData,
            "Confirmed Time", "timestamp", null
          ),
        ],
      )
    );
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
        cardContent(context, queryAccountName, null),
        cardContentGap(),
        buildTitleAndContent(
          context,
          chainInfoBloc.accountData,
          "Gas Balance", "balance", null
        ),
        buildTitleAndContent(
          context,
          chainInfoBloc.accountData,
          "Account Address", "id", null
        ),
      ],
    ));
  }
}