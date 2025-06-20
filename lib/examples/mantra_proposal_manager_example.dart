import "package:hnotes/infrastructure/blockchain/contract_repository.dart";
import "package:hnotes/infrastructure/constants.dart";

/// Example usage specific to the Mantra Proposal Manager contract
/// This contract supports: config, proposal, proposals, status, ownership

const String contractAddress = "mantra17p9u09rgfd2nwr52ayy0aezdc42r2xd2g5d70u00k5qyhzjqf89q08tazu";

class MantraProposalManagerExample {
  final ContractRepository _contractRepo;

  MantraProposalManagerExample({String? rpcEndpoint}) 
    : _contractRepo = ContractRepository(
        rpcEndpoint: rpcEndpoint ?? chainRpcUrl,
      );

  /// Demonstrate the actual supported queries for this specific contract
  Future<void> runExample() async {
    print("🚀 Mantra Proposal Manager Contract Example");
    print("📄 Contract Address: ${ContractRepository.contractAddress}");
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
      final config = await _contractRepo.queryContract({"config": {}});
      print("✅ Config: $config");
      
      if (config != null && config["successful_proposal_fee"] != null) {
        final fee = config["successful_proposal_fee"];
        print('   💰 Successful Proposal Fee: ${fee['amount']} ${fee['denom']}');
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
    print("📝 === Getting Proposals List ===");
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
            print('      ${i + 1}. ID: ${proposal['id'] ?? 'N/A'} - Title: ${proposal['title'] ?? 'N/A'}');
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
        "proposal": {"id": 1}
      });
      print("✅ Proposal #1: $proposal");
    } catch (e) {
      print("❌ Specific proposal query failed (proposal may not exist): $e");
      
      // Try alternative ID formats
      try {
        final proposal = await _contractRepo.queryContract({
          "proposal": {"proposal_id": 1}
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
      print('   Creator: ${codeInfo?['code_info']?['creator']}');
      print('   Data Hash: ${codeInfo?['code_info']?['data_hash']}');
    } catch (e) {
      print("❌ Failed to get code info: $e");
    }
    print("");
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
  
  print("=" * 60);
  print("✅ Example completed!");
}
