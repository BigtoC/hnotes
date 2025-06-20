import "package:hnotes/infrastructure/blockchain/contract_repository.dart";
import "package:hnotes/infrastructure/constants.dart";

/// Example usage specific to the Mantra Proposal Manager contract
/// This contract supports: config, proposal, proposals, status, ownership

const String contractAddress =
    "mantra17p9u09rgfd2nwr52ayy0aezdc42r2xd2g5d70u00k5qyhzjqf89q08tazu";
const String exampleRestEndpoint = "https://api.dukong.mantrachain.io";

class MantraProposalManagerExample {
  final ContractRepository _contractRepo;

  MantraProposalManagerExample({String? rpcEndpoint, String? restEndpoint})
    : _contractRepo = ContractRepository(
        rpcEndpoint: rpcEndpoint ?? chainRpcUrl,
        restEndpoint: restEndpoint ?? exampleRestEndpoint,
        contractAddress: contractAddress,
      );

  /// Demonstrate the actual supported queries for this specific contract
  Future<void> runExample() async {
    print("🚀 Mantra Proposal Manager Contract Example");
    print("📄 Contract Address: ${_contractRepo.contractAddress}");
    print("🌐 RPC Endpoint: ${_contractRepo.rpcEndpoint}");
    print("");

    try {
      // Test connection first
      print("🔌 Testing connection...");
      final isConnected = await _contractRepo.testConnection();
      if (!isConnected) {
        print("❌ Connection failed");
        return;
      }
      print("✅ Connected successfully!");
      print("");

      // 1. Get contract configuration
      await _queryConfig();

      // 2. Get ownership information
      await _queryOwnership();

      // 3. Get contract status
      await _queryStatus();

      // 4. Get proposals list
      await _queryProposals();

      // 5. Example of querying a specific proposal (if any exist)
      await _querySpecificProposal();
    } catch (e) {
      print("❌ Error during example: $e");
    }
  }

  Future<void> _queryConfig() async {
    print("📋 === Getting Contract Configuration ===");
    try {
      final config = await _contractRepo.getConfig();
      print("✅ Config: $config");

      if (config != null && config["successful_proposal_fee"] is Map) {
        final fee = config["successful_proposal_fee"] as Map;
        final amount = fee["amount"] ?? "N/A";
        final denom = fee["denom"] ?? "N/A";
        print("   💰 Successful Proposal Fee: $amount $denom");
      }
    } catch (e) {
      print("❌ Config query failed: $e");
    }
    print("");
  }

  Future<void> _queryOwnership() async {
    print("👤 === Getting Ownership Information ===");
    try {
      final ownership = await _contractRepo.queryContract({"ownership": {}});
      print("✅ Ownership: $ownership");
    } catch (e) {
      print("❌ Ownership query failed: $e");
    }
    print("");
  }

  Future<void> _queryStatus() async {
    print("📊 === Getting Contract Status ===");
    try {
      final status = await _contractRepo.queryContract({"status": {}});
      print("✅ Status: $status");
    } catch (e) {
      print("❌ Status query failed: $e");
    }
    print("");
  }

  Future<void> _queryProposals() async {
    print("📝 === Getting Proposals List ====");
    try {
      // Query all proposals (may need pagination parameters)
      final proposals = await _contractRepo.queryContract({"proposals": {}});
      print("✅ Proposals: $proposals");

      if (proposals != null && proposals["proposals"] is List) {
        final proposalsList = proposals["proposals"] as List;
        print("   📊 Total proposals found: ${proposalsList.length}");

        if (proposalsList.isNotEmpty) {
          print("   📋 Recent proposals:");
          for (int i = 0; i < proposalsList.length && i < 3; i++) {
            final proposal = proposalsList[i];
            if (proposal is Map) {
              print(
                '      ${i + 1}. ID: ${proposal["id"] ?? "N/A"} - '
                    'Title: ${proposal["title"] ?? "N/A"}',
              );
            }
          }
        }
      }
    } catch (e) {
      print("❌ Proposals query failed: $e");
    }
    print("");
  }

  Future<void> _querySpecificProposal() async {
    print("🔍 === Querying Specific Proposal ===");
    try {
      // Try to get proposal with ID 1 (common starting ID)
      final proposal = await _contractRepo.queryContract({
        "proposal": {"id": 1},
      });
      print("✅ Proposal #1: $proposal");
    } catch (e) {
      print("❌ Specific proposal query failed (proposal may not exist): $e");

      // Try alternative ID formats
      try {
        final proposal = await _contractRepo.queryContract({
          "proposal": {"proposal_id": 1},
        });
        print("✅ Proposal #1 (alt format): $proposal");
      } catch (e2) {
        print("❌ Alternative proposal query also failed: $e2");
      }
    }
    print("");
  }

  /// Helper method to get contract info and code info
  Future<void> getContractDetails() async {
    print("ℹ️  === Contract Details ===");

    try {
      final contractInfo = await _contractRepo.getContractInfo();
      print("✅ Contract Info:");
      print('   Admin: ${contractInfo?['contract_info']?['admin']}');
      print('   Creator: ${contractInfo?['contract_info']?['creator']}');
      print('   Code ID: ${contractInfo?['contract_info']?['code_id']}');
      print('   Label: ${contractInfo?['contract_info']?['label']}');
    } catch (e) {
      print("❌ Failed to get contract info: $e");
    }

    try {
      final codeInfo = await _contractRepo.getContractCode();
      print("✅ Code Info:");
      final creator = codeInfo?["code_info"]?["creator"] ?? "N/A";
      final dataHash = codeInfo?["code_info"]?["data_hash"] ?? "N/A";
      print("   Creator: $creator");
      print("   Data Hash: $dataHash");
    } catch (e) {
      print("❌ Failed to get code info: $e");
    }
    print("");
  }

  /// This method demonstrates the generic query functions
  /// from the ContractRepository.
  /// These functions are helpers for common query patterns and may or may not
  /// be supported by the specific contract being queried.
  Future<void> demonstrateGenericQueries() async {
    print("\n${"=" * 60}");
    print("🔬 Demonstrating Generic Contract Query Helpers");
    print("These may fail if the contract doesn't support them.");
    print("=" * 60);

    // 1. getConfig
    print("\n📋 1. Querying Config (generic helper)...");
    try {
      final config = await _contractRepo.getConfig();
      print("✅ Success: $config");
    } catch (e) {
      print(
        "❌ Failed: This contract might not support a 'config' query "
            "or has a different structure.",
      );
    }

    // 2. getState
    print("\n📊 2. Querying State (generic helper)...");
    try {
      final state = await _contractRepo.getState();
      print("✅ Success: $state");
    } catch (e) {
      print("❌ Failed: This contract might not support a 'state' query.");
    }

    // 3. getTokenInfo
    print("\n🪙 3. Querying Token Info (generic helper)...");
    try {
      final tokenInfo = await _contractRepo.getTokenInfo();
      print("✅ Success: $tokenInfo");
    } catch (e) {
      print("❌ Failed: This is likely not a CW20 token contract.");
    }

    // 4. getBalance
    print("\n💰 4. Querying Balance (generic helper)...");
    try {
      // Using a dummy address for demonstration purposes
      const dummyAddress = "mantra1dfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdf";
      final balance = await _contractRepo.getBalance(dummyAddress);
      print("✅ Success: $balance");
    } catch (e) {
      print("❌ Failed: This contract might not support a 'balance' query.");
    }
    print("\n${"=" * 60}");
  }
}

/// Main function to run the example
void main() async {
  final example = MantraProposalManagerExample();

  print("🎯 Starting Mantra Proposal Manager Contract Example");
  print("⏰ ${DateTime.now()}");
  print("=" * 60);

  await example.getContractDetails();
  await example.runExample();
  await example.demonstrateGenericQueries();

  print("=" * 60);
  print("✅ Example completed!");
}
