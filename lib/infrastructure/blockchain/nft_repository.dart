import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart';

import 'package:hnotes/domain/blockchain/dtos/nft_raw_dto.dart';
import 'package:hnotes/domain/blockchain/dtos/nft_metadata_dto.dart';
import 'package:hnotes/infrastructure/local_storage/files/nft_file_repository.dart';
import 'package:hnotes/infrastructure/blockchain/base_blockchain_repository.dart';

class NftRepository extends BaseBlockchainRepository {
  NftFileRepository _nftFileRepository = new NftFileRepository();

  Future<NftMetaDataDto> getNFTMetadata(
      String contractAddress, int tokenId, String tokenType) async {
    final String methodName = "getNFTMetadata";
    final String param = "contractAddress=$contractAddress&tokenId=$tokenId&tokenType=$tokenType";

    return await makeGetRequest(methodName, param).then((response) async {
      Utf8Decoder decoder = new Utf8Decoder();
      NftMetaDataDto dto = NftMetaDataDto.fromJson(jsonDecode(decoder.convert(response.bodyBytes)));
      dto = await validateMetadata(dto);
      return dto;
    });
  }

  Future<NftRawDto> getNftRaw(NftMetaDataDto nftMetaDataDto) async {
    late Uri requestUrl;
    Uri rawUri = Uri.parse(nftMetaDataDto.tokenUri.raw);
    if (rawUri.scheme != "ipfs") {
      requestUrl = rawUri;
    } else {
      requestUrl = Uri.parse(nftMetaDataDto.tokenUri.gateway);
    }

    return await client.get(requestUrl).then((response) {
      NftRawDto raw = NftRawDto.fromJson(jsonDecode(response.body));
      return raw;
    });
  }

  Future<String> downloadImage(String url, String fileName) async {
    // Reference: https://stackoverflow.com/questions/52299112/flutter-download-an-image-from-url
    Response response = await get(Uri.parse(url));
    Uint8List content = response.bodyBytes;
    String savedFileName = await _nftFileRepository.saveBytesFile(content, "$fileName.png");
    return savedFileName;
  }

  Future<NftMetaDataDto> validateMetadata(NftMetaDataDto nftMetaDataDto) async {
    if (nftMetaDataDto.metaData["url"] == null) {
      NftRawDto rawDto = await getNftRaw(nftMetaDataDto);
      Map<String, dynamic> tmpMap = nftMetaDataDto.metaData;
      tmpMap["url"] = rawDto.url;
      nftMetaDataDto.metaData = tmpMap;
      nftMetaDataDto.nftRawDto = rawDto;

      if (nftMetaDataDto.title != rawDto.name) {
        nftMetaDataDto.title = rawDto.name;
      }
      if (nftMetaDataDto.description != rawDto.description) {
        nftMetaDataDto.description = rawDto.description;
      }
    }
    return nftMetaDataDto;
  }
}
