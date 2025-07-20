import "package:blockchain_utils/bech32/bech32_base.dart";
import "package:blockchain_utils/bip/address/addr_dec_utils.dart";
import "package:blockchain_utils/bip/address/eth_addr.dart";
import "package:blockchain_utils/bip/coin_conf/constant/coins_conf.dart";
import "package:blockchain_utils/hex/hex.dart";

class EthBech32Converter {
  /// Encodes an Ethereum address in Bech32 format.
  /// This method takes a hexadecimal Ethereum address and a prefix,
  /// converts the address to bytes, and then encodes to Bech32-format address.
  ///
  /// Parameters:
  ///   - hexAddress: The hexadecimal representation of the Ethereum address.
  ///   - prefix: The Bech32 prefix to be used for encoding.
  ///
  /// Returns:
  ///   A Bech32-encoded address.
  ///
  /// Throws:
  ///  - AssertionError: If the length of the cleaned hexadecimal address is not equal to the expected Ethereum address length.
  static String ethAddressToBech32(String ethAddress, prefix) {

    final cleanHex = AddrDecUtils.validateAndRemovePrefix(
        ethAddress, CoinsConf.ethereum.params.addrPrefix!
    );
    assert(
    cleanHex.length == EthAddrConst.addrLen,
    "Invalid Ethereum address length: ${cleanHex.length}, expected: ${EthAddrConst.addrLen}"
    );
    final hexAddressBytes = hex.decode(cleanHex);
    return Bech32Encoder.encode(prefix, hexAddressBytes);
  }

  /// Decodes a Bech32-encoded address.
  /// This method takes a Bech32-encoded address
  /// and decodes it to its hexadecimal representation.
  ///
  /// Parameters:
  ///   - bech32Address: The Bech32-encoded Ethereum address.
  ///
  /// Returns:
  ///   A string representing the Ethereum address.
  static String bech32ToEthAddress(String bech32Address, prefix) {
    final decoded = Bech32Decoder.decode(prefix, bech32Address);
    final hexEncoded = hex.encode(decoded);
    assert(
    hexEncoded.length == EthAddrConst.addrLen,
    "Invalid Ethereum address length: ${hexEncoded.length}, expected: ${EthAddrConst.addrLen}"
    );
    return "${CoinsConf.ethereum.params.addrPrefix!}$hexEncoded";
  }
}
