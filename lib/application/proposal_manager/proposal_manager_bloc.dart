import 'dart:async';
import 'package:hnotes/infrastructure/blockchain/contract_repository.dart';
import 'package:hnotes/infrastructure/constants.dart';

class ProposalManagerBloc {
  static const String contractAddress = "mantra17p9u09rgfd2nwr52ayy0aezdc42r2xd2g5d70u00k5qyhzjqf89q08tazu";
  
  late final ContractRepository _contractRepository;
  
  // Stream controllers
  final StreamController<Map<String, dynamic>?> _contractStatusController = StreamController<Map<String, dynamic>?>.broadcast();
  final StreamController<List<Map<String, dynamic>>> _proposalsController = StreamController<List<Map<String, dynamic>>>.broadcast();
  final StreamController<Map<String, dynamic>?> _contractConfigController = StreamController<Map<String, dynamic>?>.broadcast();
  
  // Stream getters
  Stream<Map<String, dynamic>?> get contractStatusStream => _contractStatusController.stream;
  Stream<List<Map<String, dynamic>>> get proposalsStream => _proposalsController.stream;
  Stream<Map<String, dynamic>?> get contractConfigStream => _contractConfigController.stream;
  
  ProposalManagerBloc() {
    _contractRepository = ContractRepository(
      rpcEndpoint: chainRpcUrl,
      restEndpoint: chainRestUrl,
    );
    
    // Initialize streams with empty/null values to prevent null errors
    _contractStatusController.add(null);
    _proposalsController.add([]);
    _contractConfigController.add(null);
  }
  
  /// Load all contract data (status, config, proposals)
  Future<void> loadContractData() async {
    try {
      // Load contract status
      await loadContractStatus();
      
      // Load contract config
      await loadContractConfig();
      
      // Load proposals
      await loadProposals();
    } catch (e) {
      _contractStatusController.addError(e);
      _proposalsController.addError(e);
      _contractConfigController.addError(e);
    }
  }
  
  /// Load contract status
  Future<void> loadContractStatus() async {
    try {
      final status = await _contractRepository.queryContract({'status': {}});
      _contractStatusController.add(status);
    } catch (e) {
      _contractStatusController.addError(e);
    }
  }
  
  /// Load contract configuration
  Future<void> loadContractConfig() async {
    try {
      final config = await _contractRepository.queryContract({'config': {}});
      _contractConfigController.add(config);
    } catch (e) {
      _contractConfigController.addError(e);
    }
  }
  
  /// Load all proposals
  Future<void> loadProposals() async {
    try {
      final result = await _contractRepository.queryContract({'proposals': {}});
      if (result != null && result['proposals'] is List) {
        final proposals = (result['proposals'] as List)
            .map((proposal) => proposal as Map<String, dynamic>)
            .toList();
        _proposalsController.add(proposals);
      } else {
        _proposalsController.add([]);
      }
    } catch (e) {
      _proposalsController.addError(e);
    }
  }
  
  /// Get specific proposal by ID
  Future<Map<String, dynamic>?> getProposal(int proposalId) async {
    try {
      return await _contractRepository.queryContract({
        'proposal': {'id': proposalId}
      });
    } catch (e) {
      rethrow;
    }
  }
  
  /// Get contract ownership information
  Future<Map<String, dynamic>?> getOwnership() async {
    try {
      return await _contractRepository.queryContract({'ownership': {}});
    } catch (e) {
      rethrow;
    }
  }
  
  /// Test connection to the contract
  Future<bool> testConnection() async {
    try {
      return await _contractRepository.testConnection();
    } catch (e) {
      return false;
    }
  }
  
  /// Get contract info
  Future<Map<String, dynamic>?> getContractInfo() async {
    try {
      return await _contractRepository.getContractInfo();
    } catch (e) {
      rethrow;
    }
  }
  
  /// Dispose resources
  void dispose() {
    _contractStatusController.close();
    _proposalsController.close();
    _contractConfigController.close();
  }
}

// Global instance
final proposalManagerBloc = ProposalManagerBloc();
