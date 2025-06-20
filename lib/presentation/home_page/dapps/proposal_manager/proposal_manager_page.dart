import "package:flutter/material.dart";
import "package:hnotes/infrastructure/blockchain/contract_repository.dart";
import "package:hnotes/infrastructure/constants.dart";

const String proposalManagerContractAddress =
    "mantra17p9u09rgfd2nwr52ayy0aezdc42r2xd2g5d70u00k5qyhzjqf89q08tazu";

class ProposalManagerPage extends StatefulWidget {
  final ContractRepository? contractRepository;

  const ProposalManagerPage({super.key, this.contractRepository});

  @override
  State<ProposalManagerPage> createState() => _ProposalManagerPageState();
}

class _ProposalManagerPageState extends State<ProposalManagerPage> {
  late final ContractRepository _contractRepository;
  late Future<Map<String, dynamic>> _loadDataFuture;

  @override
  void initState() {
    super.initState();
    _contractRepository = widget.contractRepository ??
        ContractRepository(
          rpcEndpoint: chainRpcUrl,
          restEndpoint: chainRestUrl,
          contractAddress: proposalManagerContractAddress,
        );
    _loadDataFuture = _loadData();
  }

  Future<Map<String, dynamic>> _loadData() async {
    try {
      // Query data directly from the contract
      final statusQuery = _contractRepository.queryContract({"status": {}});
      final proposalsQuery = _contractRepository.queryContract({
        "proposals": {},
      });

      // Wait for both queries to complete
      final results = await Future.wait([statusQuery, proposalsQuery]);

      final status = results[0];
      final proposalsResult = results[1];

      List<Map<String, dynamic>> proposals = [];
      if (proposalsResult != null && proposalsResult["proposals"] is List) {
        proposals = (proposalsResult["proposals"] as List)
            .map((proposal) => proposal as Map<String, dynamic>)
            .toList();
      }

      return {"status": status, "proposals": proposals};
    } catch (e) {
      throw Exception("Failed to load contract data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _loadDataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text("Loading contract data..."),
                ],
              ),
            ),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.error, color: Colors.red, size: 48),
                      const SizedBox(height: 16),
                      Text(
                        "Error: ${snapshot.error}",
                        style: const TextStyle(color: Colors.red),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          // Trigger a rebuild to retry
                          (context as Element).markNeedsBuild();
                        },
                        child: const Text("Retry"),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }

        final data = snapshot.data!;
        final status = data["status"] as Map<String, dynamic>?;
        final proposals =
            data["proposals"] as List<Map<String, dynamic>>? ?? [];

        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Status Card
              if (status != null) ...[
                Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Contract Status",
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 12),
                        _buildStatusRow(
                          "Total",
                          status["total_proposals"]?.toString() ?? "0",
                        ),
                        _buildStatusRow(
                          "Pending",
                          status["total_proposals_pending"]?.toString() ?? "0",
                        ),
                        _buildStatusRow(
                          "Approved",
                          status["total_proposals_yes"]?.toString() ?? "0",
                        ),
                        _buildStatusRow(
                          "Rejected",
                          status["total_proposals_no"]?.toString() ?? "0",
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // Proposals
              Text(
                "Proposals (${proposals.length})",
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),

              if (proposals.isEmpty)
                const Card(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Text("No proposals found"),
                  ),
                )
              else
                ...List.generate(proposals.length, (index) {
                  final proposal = proposals[index];
                  return _buildProposalCard(proposal);
                }),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatusRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildProposalCard(Map<String, dynamic> proposal) {
    final proposalId = proposal["id"]?.toString() ?? "N/A";
    final status = proposal["status"]?.toString() ?? "Unknown";
    final title = proposal["title"]?.toString();
    final speech = proposal["speech"]?.toString();
    final proposer = proposal["proposer"]?.toString() ?? "Unknown";
    final receiver = proposal["receiver"]?.toString() ?? "Unknown";

    Color statusColor;
    switch (status.toLowerCase()) {
      case "yes":
        statusColor = Colors.green;
        break;
      case "no":
        statusColor = Colors.red;
        break;
      default:
        statusColor = Colors.grey;
    }

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Proposal #$proposalId",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withAlpha(10),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: statusColor),
                  ),
                  child: Text(
                    status.toUpperCase(),
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (title != null && title.isNotEmpty)
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            const SizedBox(height: 4),
            if (speech != null && speech.isNotEmpty)
              SelectableText(speech, style: const TextStyle(fontSize: 14)),
            Text("From: ${_shortenAddress(proposer)}"),
            Text("To: ${_shortenAddress(receiver)}"),
          ],
        ),
      ),
    );
  }

  String _shortenAddress(String address) {
    if (address.length <= 20) return address;
    final firstPart = address.substring(0, 10);
    final lastPart = address.substring(address.length - 6);
    return "$firstPart...$lastPart";
  }
}
