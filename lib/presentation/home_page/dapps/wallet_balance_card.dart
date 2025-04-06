import "package:flutter/cupertino.dart";

import "package:hnotes/application/wallet/wallet_bloc.dart";
import "package:hnotes/domain/common_data.dart";
import "package:hnotes/presentation/components/loading_circle.dart";
import "package:hnotes/presentation/home_page/base/one_dapp_widget.dart";

class WalletBalanceCard extends StatefulWidget {
  const WalletBalanceCard({super.key});

  @override
  State<WalletBalanceCard> createState() => _WalletBalanceCardState();
}

class _WalletBalanceCardState extends State<WalletBalanceCard> {
  @override
  void initState() {
    super.initState();
    walletBloc.getAddressAndBalance();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: walletBloc.addressAndBalanceStream,
        builder: (context, AsyncSnapshot<Map<String, String>> snapshot) {
          if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}");
          }
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return Text("Query data failed...");
            case ConnectionState.waiting:
              return Center(child: LoadingCircle());
            case ConnectionState.active:
              String address = snapshot.data!["address"].toString();
              String balance = snapshot.data!["balance"].toString();
              return OneDappWidget(
                dAppName: "Wallet Balance",
                cardContent: "$address\n\n$balance",
              );
            case ConnectionState.done:
              logger.i("Finish rendering Wallet Balance");
          }
          return SizedBox();
        }
    );
  }
}
