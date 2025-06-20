import "dart:convert";
import "package:http/http.dart" as http;
import "package:logger/logger.dart";
import "package:cosmos_sdk/cosmos_sdk.dart";
import "package:blockchain_utils/service/service.dart";

/// HTTP Provider implementation for TendermintServiceProvider
class _TendermintHTTPProvider implements TendermintServiceProvider {
  _TendermintHTTPProvider({
    required this.url,
    http.Client? client,
  }) : client = client ?? http.Client();

  final String url;
  final http.Client client;
  final Duration defaultRequestTimeout = const Duration(seconds: 30);

  @override
  Future<BaseServiceResponse<T>> doRequest<T>(TendermintRequestDetails params,
      {Duration? timeout}) async {
    final uri = params.toUri(url);
    if (params.type.isPostRequest) {
      final response = await client
          .post(uri, headers: params.headers, body: params.body())
          .timeout(timeout ?? defaultRequestTimeout);
      return params.toResponse(response.bodyBytes, response.statusCode);
    }
    final response = await client.get(uri,
        headers: {...params.headers}).timeout(timeout ?? defaultRequestTimeout);
    return params.toResponse(response.bodyBytes, response.statusCode);
  }

  void dispose() {
    client.close();
  }
}

/// Repository for interacting with Mantra chain smart contracts
class ContractRepository {
  final Logger _logger = Logger();

  final String rpcEndpoint;
  final String restEndpoint;
  final String contractAddress;
  late final TendermintProvider provider;
  late final _TendermintHTTPProvider _httpProvider;

  ContractRepository({
    required this.rpcEndpoint,
    required this.restEndpoint,
    required this.contractAddress,
  }) {
    _httpProvider = _TendermintHTTPProvider(url: rpcEndpoint);
    provider = TendermintProvider(_httpProvider);
  }

  void dispose() {
    _httpProvider.dispose();
  }

  /// Query smart contract with a specific message using cosmos_sdk
  Future<Map<String, dynamic>?> queryContract(Map<String, dynamic> queryMsg) async {
    try {
      _logger.i("Querying contract: $contractAddress with message: $queryMsg");
      
      // Encode the query message to bytes
      final queryBytes = utf8.encode(json.encode(queryMsg));
      
      // Create the smart contract state request
      final smartContractRequest = CosmWasmV1QuerySmartContractStateRequest(
        address: contractAddress,
        queryData: queryBytes,
      );
      
      // Execute the query using Tendermint provider
      final response = await provider.request(
        TendermintRequestAbciQuery(request: smartContractRequest)
      );
      
      _logger.i("Query successful");
      
      // Parse and return the response data
      if (response.data != null) {
        final jsonString = utf8.decode(response.data!);
        return json.decode(jsonString) as Map<String, dynamic>?;
      }
      
      return null;
    } catch (e) {
      _logger.e("Error querying contract: $e");
      throw Exception("Failed to query contract");
    }
  }

  /// Get contract information using cosmos_sdk
  Future<Map<String, dynamic>?> getContractInfo() async {
    try {
      _logger.i("Getting contract info for: $contractAddress");
      
      // Create the contract info request
      final contractInfoRequest = CosmWasmV1QueryContractInfoRequest(contractAddress);
      
      // Execute the query using Tendermint provider
      final response = await provider.request(
        TendermintRequestAbciQuery(request: contractInfoRequest)
      );
      
      _logger.i("Contract info retrieved successfully");
      
      // Convert the response to JSON format
      return response.toJson();
    } catch (e) {
      _logger.e("Error getting contract info: $e");
      throw Exception("Error getting contract info: $e");
    }
  }

  /// Query contract state with raw query using cosmos_sdk
  Future<Map<String, dynamic>?> queryContractRaw(List<int> queryData) async {
    try {
      _logger.i("Querying contract with raw data: ${queryData.length} bytes");
      
      // Create the raw contract state request
      final rawContractRequest = CosmWasmV1QueryRawContractStateRequest(
        address: contractAddress,
        queryData: queryData,
      );
      
      // Execute the query using Tendermint provider
      final response = await provider.request(
        TendermintRequestAbciQuery(request: rawContractRequest)
      );
      
      _logger.i("Raw query successful");
      
      // Convert the response to JSON format
      return response.toJson();
    } catch (e) {
      _logger.e("Error in raw query: $e");
      throw Exception("Error in raw query: $e");
    }
  }

  /// Get contract code information
  Future<Map<String, dynamic>?> getContractCode() async {
    try {
      // First get contract info to get the code_id
      final contractInfo = await getContractInfo();
      if (contractInfo?["contract_info"]?["code_id"] == null) {
        throw Exception("Could not retrieve code_id from contract info");
      }
      
      final codeId = contractInfo!["contract_info"]["code_id"];
      _logger.i("Getting code info for code_id: $codeId");
      
      final url = "$restEndpoint/cosmwasm/wasm/v1/code/$codeId";
      final response = await http.get(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
      );
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _logger.i("Contract code info retrieved successfully");
        return data;
      } else {
        _logger.e("Failed to get contract code: ${response.statusCode}");
        throw Exception("Failed to get contract code: ${response.statusCode}");
      }
    } catch (e) {
      _logger.e("Error getting contract code: $e");
      throw Exception("Error getting contract code: $e");
    }
  }

  /// Test RPC endpoint connectivity
  Future<bool> testConnection() async {
    try {
      _logger.i("Testing connection to: $rpcEndpoint");
      
      // Try to get chain status
      final url = "$rpcEndpoint/status";
      final response = await http.get(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
      );
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _logger.i('Connection successful. Chain ID: ${data['result']?['node_info']?['network']}');
        return true;
      } else {
        _logger.w("Connection test failed: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      _logger.e("Connection test error: $e");
      return false;
    }
  }

  /// Get chain information
  Future<Map<String, dynamic>?> getChainInfo() async {
    try {
      final url = "$rpcEndpoint/status";
      final response = await http.get(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
      );
      
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception("Failed to get chain info: ${response.statusCode}");
      }
    } catch (e) {
      _logger.e("Error getting chain info: $e");
      throw Exception("Error getting chain info: $e");
    }
  }

  /// Example query methods - adjust based on your contract's interface
  
  /// Query contract configuration (common in many contracts)
  Future<Map<String, dynamic>?> getConfig() async {
    return await queryContract({"config": {}});
  }

  /// Query contract state (common in many contracts)
  Future<Map<String, dynamic>?> getState() async {
    return await queryContract({"state": {}});
  }

  /// Query balance for an address (if contract supports it)
  Future<Map<String, dynamic>?> getBalance(String address) async {
    return await queryContract({
      "balance": {"address": address}
    });
  }

  /// Query all balances (if contract supports it)
  Future<Map<String, dynamic>?> getAllBalances() async {
    return await queryContract({"all_balances": {}});
  }

  /// Query token info (if it's a token contract)
  Future<Map<String, dynamic>?> getTokenInfo() async {
    return await queryContract({"token_info": {}});
  }

  /// Query allowance (if it's a token contract)
  Future<Map<String, dynamic>?> getAllowance(String owner, String spender) async {
    return await queryContract({
      "allowance": {
        "owner": owner,
        "spender": spender,
      }
    });
  }

  /// Generic method to execute multiple queries in parallel
  Future<List<Map<String, dynamic>?>> executeMultipleQueries(
    List<Map<String, dynamic>> queries,
  ) async {
    try {
      _logger.i("Executing ${queries.length} queries in parallel");
      
      final futures = queries.map((query) => queryContract(query)).toList();
      final results = await Future.wait(futures);
      
      _logger.i("All queries completed successfully");
      return results;
    } catch (e) {
      _logger.e("Error executing multiple queries: $e");
      rethrow;
    }
  }
}


