import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:hnotes/presentation/home_page/dapps/proposal_manager/proposal_manager_page.dart";

void main() {
  group("ProposalManagerPage Widget Tests", () {
    testWidgets("should render without null check errors", (
      WidgetTester tester,
    ) async {
      // Build the widget
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ListView(children: const [ProposalManagerPage()]),
          ),
        ),
      );

      // Wait for initial state
      await tester.pump();

      // Should show loading state
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text("Loading contract data..."), findsOneWidget);

      // Wait longer for the data loading to complete or timeout
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Should either show error state or loaded data
      // No null check errors should occur during rendering
      expect(find.byType(ProposalManagerPage), findsOneWidget);
    });

    testWidgets("should handle parent ListView without layout conflicts", (
      WidgetTester tester,
    ) async {
      // Test that it works properly inside DAppDetailsPage-like structure
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ListView(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  child: const Text("Header"),
                ),
                const ProposalManagerPage(),
                Container(
                  padding: const EdgeInsets.all(16),
                  child: const Text("Footer"),
                ),
              ],
            ),
          ),
        ),
      );

      await tester.pump();

      // Should render without layout conflicts
      expect(find.text("Header"), findsOneWidget);
      expect(find.text("Footer"), findsOneWidget);
      expect(find.byType(ProposalManagerPage), findsOneWidget);

      // No RenderFlex overflow or null check errors
      await tester.pumpAndSettle(const Duration(seconds: 1));
    });
  });
}
