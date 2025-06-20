import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:hnotes/presentation/home_page/dapps/proposal_manager/proposal_manager_page.dart";
import "package:mockito/mockito.dart";

import "mocks.mocks.dart";

void main() {
  group("ProposalManagerPage Widget Tests", () {
    late MockContractRepository mockContractRepository;

    setUp(() {
      mockContractRepository = MockContractRepository();
    });

    testWidgets("should render loading indicator and then data", (
      WidgetTester tester,
    ) async {
      // Mock the contract calls
      when(
        mockContractRepository.queryContract(argThat(equals({"status": {}}))),
      ).thenAnswer((_) async {
        await Future.delayed(const Duration(milliseconds: 10));
        return {
          "total_proposals": 10,
          "total_proposals_pending": 2,
          "total_proposals_yes": 5,
          "total_proposals_no": 3,
        };
      });
      when(
        mockContractRepository.queryContract(
          argThat(equals({"proposals": {}})),
        ),
      ).thenAnswer((_) async {
        await Future.delayed(const Duration(milliseconds: 10));
        return {
          "proposals": [
            {
              "id": 1,
              "title": "Test Proposal 1",
              "status": "yes",
              "proposer": "mantra1...",
              "receiver": "mantra1...",
            },
          ],
        };
      });

      // Build the widget
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ListView(
              children: [
                ProposalManagerPage(contractRepository: mockContractRepository),
              ],
            ),
          ),
        ),
      );

      // First frame, should show loading indicator
      await tester.pump();
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text("Loading contract data..."), findsOneWidget);

      // Settle the futures
      await tester.pumpAndSettle();

      // Should show the loaded data
      expect(find.text("Contract Status"), findsOneWidget);
      expect(find.text("Proposals (1)"), findsOneWidget);
      expect(find.text("Test Proposal 1"), findsOneWidget);
    });

    testWidgets("should show error message when data loading fails", (
      WidgetTester tester,
    ) async {
      // Mock the contract calls to throw an error
      when(mockContractRepository.queryContract(any)).thenAnswer((_) async {
        await Future.delayed(const Duration(milliseconds: 10));
        throw Exception("Network Error");
      });

      // Build the widget
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ListView(
              children: [
                ProposalManagerPage(contractRepository: mockContractRepository),
              ],
            ),
          ),
        ),
      );

      // First frame, should show loading indicator
      await tester.pump();
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Settle the futures
      await tester.pumpAndSettle();

      // Should show the error message
      expect(find.textContaining("Error:"), findsOneWidget);
      expect(
        find.textContaining(
          "Failed to load contract data: Exception: Network Error",
        ),
        findsOneWidget,
      );
      expect(find.byType(ElevatedButton), findsOneWidget); // Retry button
    });

    testWidgets("should handle parent ListView without layout conflicts", (
      WidgetTester tester,
    ) async {
      // Mock the contract calls to return empty data
      when(
        mockContractRepository.queryContract(any),
      ).thenAnswer((_) async => {"proposals": [], "status": null});

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
                ProposalManagerPage(contractRepository: mockContractRepository),
                Container(
                  padding: const EdgeInsets.all(16),
                  child: const Text("Footer"),
                ),
              ],
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Should render without layout conflicts
      expect(find.text("Header"), findsOneWidget);
      expect(find.text("Footer"), findsOneWidget);
      expect(find.byType(ProposalManagerPage), findsOneWidget);
      expect(find.text("No proposals found"), findsOneWidget);
    });
  });
}
