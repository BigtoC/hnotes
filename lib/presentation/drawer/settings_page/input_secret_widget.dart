import "package:flutter/material.dart";

import "package:hnotes/presentation/theme.dart";
import "package:hnotes/domain/secret/secret_model.dart";
import "package:hnotes/application/secret/secret_bloc.dart";
import "package:hnotes/presentation/components/build_card_widget.dart";
import "package:hnotes/infrastructure/local_storage/secrets/secrets_repository.dart";

class InputApiSecretWidget extends StatefulWidget {
  const InputApiSecretWidget({super.key});

  @override
  State<StatefulWidget> createState() => _InputApiSecretWidget();
}

class _InputApiSecretWidget extends State<InputApiSecretWidget> {
  TextEditingController _secretController = TextEditingController();
  bool _hidePassword = true;
  bool _isSaved = false;

  @override
  void initState() {
    super.initState();
    secretBloc.fetchSecret();
  }

  @override
  void dispose() {
    _secretController.dispose();
    super.dispose();
  }

  void saveInputUrl() {
    SecretRepository.saveApiSecret(_secretController.text);
    setState(() {
      _isSaved = true;
      _hidePassword = true;
    });
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final String fieldLabel = "API URL";
    final String defaultHintText = "https://xx.xx/v2/<API KEY>";

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
          cardTitle("Input $fieldLabel"),
          Container(height: 20),
          Padding(
            padding: EdgeInsets.all(5),
            child: StreamBuilder(
              stream: secretBloc.secretModel,
              builder: (context, AsyncSnapshot<SecretModel> snapshot) {
                if (snapshot.hasError) {
                  return Text("Error: ${snapshot.error}");
                }
                if (snapshot.hasData) {
                  String? urlWithKey = snapshot.data?.urlWithKey;
                  _secretController = TextEditingController(text: urlWithKey);
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
              onPressed: saveInputUrl,
              child: Text(
                "Save",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
