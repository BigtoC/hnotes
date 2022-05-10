import 'dart:async';
import 'dart:convert';

import 'package:hnotes/domain/blockchain/dtos/nft_metadata_dto.dart';
import 'package:hnotes/infrastructure/blockchain/base_blockchain_repository.dart';


class NftRepository extends BaseBlockchainRepository {
  Future<NftMetaDataDto> getNFTMetadata(
      String contractAddress, int tokenId, String tokenType
      ) async {
    final String methodName = "getNFTMetadata";
    final String param = "contractAddress=$contractAddress&tokenId=$tokenId&tokenType=$tokenType";

    return await makeGetRequest(methodName, param)
        .then((response) {
          NftMetaDataDto dto = NftMetaDataDto.fromJson(jsonDecode(response.body));
          return dto;
        });
  }
}
