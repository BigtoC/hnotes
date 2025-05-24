import "package:flutter/material.dart";
import "package:hnotes/application/wallet/wallet_bloc.dart";

import "package:hnotes/presentation/theme.dart";
import "package:hnotes/presentation/components/build_card_widget.dart";

class ImportWalletWidget extends StatefulWidget {
  const ImportWalletWidget({super.key});

  @override
  State<StatefulWidget> createState() => _ImportWalletWidget();
}

class _ImportWalletWidget extends State<ImportWalletWidget> {
  TextEditingController _secretController = TextEditingController();
  bool _hidePassword = true;
  bool _isSaved = false;

  @override
  void initState() {
    super.initState();
    walletBloc.fetchSecret();
    walletBloc.getImportedWalletAddress();
  }

  @override
  void dispose() {
    _secretController.dispose();
    super.dispose();
  }

  void importWallet() {
    walletBloc.importPrivateKey(_secretController.text);
    setState(() {
      _isSaved = true;
      _hidePassword = true;
    });
    FocusScope.of(context).unfocus();
    walletBloc.getImportedWalletAddress();
  }

  @override
  Widget build(BuildContext context) {
    final String fieldLabel = "Private Key";
    final String defaultHintText = "Import or generate a new wallet";

    final ButtonStyle style = ElevatedButton.styleFrom(
      backgroundColor: btnColor,
    );

    Widget inputTextField(TextEditingController controller) {
      return TextField(
        enableIMEPersonalizedLearning: false,
        enableSuggestions: false,
        autocorrect: false,
        obscureText: _hidePassword,
        controller: controller,
        decoration: InputDecoration(
          prefixIcon:
              _isSaved
                  ? Icon(Icons.check_circle, color: Colors.green)
                  : Icon(Icons.vpn_key),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          labelText: fieldLabel,
          hintText: defaultHintText,
          suffixIcon: IconButton(
            icon:
                _hidePassword
                    ? Icon(Icons.visibility_off)
                    : Icon(Icons.visibility),
            onPressed: () {
              // TODO: Add authentication logic
              setState(() {
                _hidePassword = !_hidePassword;
              });
            },
          ),
        ),
      );
    }

    return buildCardWidget(
      context,
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          cardTitle("Manage your wallet"),
          Container(height: 20),
          Padding(
            padding: EdgeInsets.all(5),
            child: StreamBuilder(
              stream: walletBloc.walletAddressStream,
              builder: (context, AsyncSnapshot<String> snapshot) {
                if (snapshot.hasError) {
                  return Container(height: 0);
                }
                if (snapshot.hasData) {
                  String? walletAddress = snapshot.data;
                  if (walletAddress != "") {
                    return Text("Wallet Address \n$walletAddress");
                  }
                }
                return Container(height: 0);
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(5),
            child: StreamBuilder(
              stream: walletBloc.walletPrivateKeyStream,
              builder: (context, AsyncSnapshot<String> snapshot) {
                if (snapshot.hasError) {
                  return Text("Error: ${snapshot.error}");
                }
                if (snapshot.hasData) {
                  String? privateKey = snapshot.data;
                  _secretController = TextEditingController(text: privateKey);
                  return inputTextField(_secretController);
                }
                return inputTextField(_secretController);
              },
            ),
          ),
          Container(height: 10),
          Center(
            child: ElevatedButton(
              style: style,
              onPressed: importWallet,
              child: Text(
                "Import",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
