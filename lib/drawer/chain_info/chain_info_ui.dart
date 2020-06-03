import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';

import 'package:hnotes/util/theme.dart';
import 'package:hnotes/util/common_data.dart';
import 'package:hnotes/util/build_card_widget.dart';
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
                buildLatestBlockInfo(context),
                buildAccountInfo(context),
              ],
            ))
        ],
      ),
    );
  }

  void handleBack() {
    Navigator.pop(context);
  }

  Widget buildLatestBlockInfo(BuildContext context) {

    return buildCardWidget(context,
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          cardTitle('Latest Block Info'),
          Container(
            height: 40,
          ),
          buildTitleAndContent(
            chainInfoBloc.blockHeaderData,
            "Block Height", "number"
          ),
          buildTitleAndContent(
            chainInfoBloc.blockHeaderData,
            "Gas Used", "gasUsed"
          ),
          buildTitleAndContent(
            chainInfoBloc.blockHeaderData,
            "Confirmed Time", "timestamp"
          ),

        ],
      )
    );
  }

  Widget buildAccountInfo(BuildContext context) {
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
        cardContent(queryAccountName),
        cardContentGap(),
        buildTitleAndContent(
          chainInfoBloc.accountData,
          "Gas Balance", "balance"
        ),
        buildTitleAndContent(
          chainInfoBloc.accountData,
          "Account Address", "id"
        ),
      ],
    ));
  }
}