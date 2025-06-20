import "package:flutter/cupertino.dart";

import "package:hnotes/presentation/components/loading_circle.dart";
import "package:hnotes/presentation/home_page/base/one_dapp_widget.dart";
import "package:hnotes/presentation/home_page/dapps/proposal_manager/proposal_manager_page.dart";
import "package:hnotes/application/proposal_manager/proposal_manager_bloc.dart";

class ProposalManagerCard extends StatefulWidget {
  const ProposalManagerCard({super.key});

  @override
  State<ProposalManagerCard> createState() => _ProposalManagerCardState();
}

class _ProposalManagerCardState extends State<ProposalManagerCard> {
  @override
  void initState() {
    super.initState();
    proposalManagerBloc.loadContractData();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: proposalManagerBloc.contractStatusStream,
      builder: (context, AsyncSnapshot<Map<String, dynamic>?> snapshot) {
        if (snapshot.hasError) {
          return Text("Error: ${snapshot.error}");
        }
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return Text("Query data failed...");
          case ConnectionState.waiting:
            return Center(child: LoadingCircle());
          case ConnectionState.active:
            if (snapshot.data == null) {
              return const Text("No proposal data available");
            }
            
            final status = snapshot.data!;
            final totalProposals = status["total_proposals"]?.toString() ?? "0";
            final pendingProposals = status["total_proposals_pending"]?.toString() ?? "0";
            final approvedProposals = status["total_proposals_yes"]?.toString() ?? "0";
            
            final cardContent = """Proposal Manager

Total: $totalProposals
Pending: $pendingProposals  
Approved: $approvedProposals""";

            return OneDappWidget(
              dAppName: "Proposal Manager",
              cardContent: cardContent,
              dAppDetailsWidget: const ProposalManagerPage(),
            );
          case ConnectionState.done:
            return const SizedBox();
        }
      },
    );
  }
}
