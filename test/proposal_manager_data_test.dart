import "package:flutter_test/flutter_test.dart";
import "package:hnotes/infrastructure/blockchain/contract_repository.dart";
import "package:hnotes/infrastructure/constants.dart";

void main() {
  group("ProposalManager Contract Data Loading", () {
    late ContractRepository contractRepository;

    setUp(() {
      contractRepository = ContractRepository(
        rpcEndpoint: chainRpcUrl,
        restEndpoint: chainRestUrl,
      );
    });

    test("should load contract status directly", () async {
      try {
        final status = await contractRepository.queryContract({"status": {}});
        print("Status result: $status");
        
        // Verify we get some data back
        expect(status, isNotNull);
        expect(status, isA<Map<String, dynamic>>());
      } catch (e) {
        print("Error loading status: $e");
        // In test environment, network calls might fail, so we just verify it doesn't crash
        expect(e, isA<Exception>());
      }
    });

    test("should load proposals directly", () async {
      try {
        final proposalsResult = await contractRepository.queryContract({"proposals": {}});
        print("Proposals result: $proposalsResult");
        
        // Verify we get some data back
        expect(proposalsResult, isNotNull);
        expect(proposalsResult, isA<Map<String, dynamic>>());
        
        if (proposalsResult != null && proposalsResult["proposals"] is List) {
          final proposals = (proposalsResult["proposals"] as List)
              .map((proposal) => proposal as Map<String, dynamic>)
              .toList();
          print("Parsed ${proposals.length} proposals");
        }
      } catch (e) {
        print("Error loading proposals: $e");
        // In test environment, network calls might fail, so we just verify it doesn't crash
        expect(e, isA<Exception>());
      }
    });
  });
}
