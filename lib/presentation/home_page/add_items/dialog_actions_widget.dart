import 'package:flutter/material.dart';

class DialogActionsWidget extends StatelessWidget {
  final Function() handleImportErc721;

  const DialogActionsWidget({super.key, required this.handleImportErc721});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: OutlinedButton(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Align(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(1, 0, 3, 1),
                      child: const Icon(Icons.clear),
                    ),
                  ),
                  const Text("Cancel")
                ],
              ),
              onPressed: () {
                Navigator.of(context).pop();
              }),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Align(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(1, 0, 3, 1),
                    child: const Icon(Icons.check),
                  ),
                ),
                const Text("Import")
              ],
            ),
            onPressed: () async {
              Navigator.of(context).pop();
              await handleImportErc721();
            },
          ),
        )
      ],
    );
  }

}