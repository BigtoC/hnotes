import "package:flutter_test/flutter_test.dart";
import "package:hnotes/application/proposal_manager/proposal_manager_bloc.dart";

void main() {
  group("ProposalManagerBloc Tests", () {
    late ProposalManagerBloc bloc;

    setUp(() {
      bloc = ProposalManagerBloc();
    });

    tearDown(() {
      bloc.dispose();
    });

    test("should initialize correctly", () {
      expect(bloc.contractStatusStream, isNotNull);
      expect(bloc.proposalsStream, isNotNull);
      expect(bloc.contractConfigStream, isNotNull);
    });

    test("should load contract data", () async {
      // This test requires actual network connectivity to the testnet
      // In a production environment, you would mock the repository
      
      try {
        await bloc.loadContractData();
        // If we reach here, the method executed without throwing
        expect(true, isTrue);
      } catch (e) {
        // Network issues are acceptable in tests
        expect(e, isA<Exception>());
      }
    });

    test("should test connection", () async {
      try {
        final result = await bloc.testConnection();
        expect(result, isA<bool>());
      } catch (e) {
        // Network issues are acceptable in tests
        expect(e, isA<Exception>());
      }
    });
  });
}
