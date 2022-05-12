import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart';

import 'package:hnotes/domain/blockchain/dtos/nft_metadata_dto.dart';
import 'package:hnotes/infrastructure/local_storage/files/folder_repository.dart';
import 'package:hnotes/infrastructure/blockchain/base_blockchain_repository.dart';

class NftRepository extends BaseBlockchainRepository {
  FolderRepository _folderRepository = new FolderRepository();
  
  Future<NftMetaDataDto> getNFTMetadata(
      String contractAddress, int tokenId, String tokenType) async {
    final String methodName = "getNFTMetadata";
    final String param = "contractAddress=$contractAddress&tokenId=$tokenId&tokenType=$tokenType";

    return await makeGetRequest(methodName, param).then((response) {
      NftMetaDataDto dto = NftMetaDataDto.fromJson(jsonDecode(response.body));
      return dto;
    });
  }

  Future<String> downloadImage(String url, String fileName) async {
    // Reference: https://stackoverflow.com/questions/52299112/flutter-download-an-image-from-url
    Response response = await get(Uri.parse(url));
    String savedFileName = await _folderRepository.saveBytesFile(response.bodyBytes, fileName);
    return savedFileName;
  }
}
