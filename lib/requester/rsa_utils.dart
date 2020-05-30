import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:asn1lib/asn1lib.dart';
import 'package:pointycastle/export.dart';

class RSAUtils {
  static RSAPublicKey publicKey;

  static RSAPrivateKey privateKey;

  static RSAUtils instance;

  //单例模式
  static RSAUtils getInstance(String publicKeyFile, String privateKeyFile) {
    if (instance == null) {
      instance = RSAUtils(publicKeyFile, privateKeyFile);
    }
    return instance;
  }

  //保证PEM证书只被解析一次
  RSAUtils(String publicKeyFile, String privateKeyFile) {
    if (publicKeyFile != null) {
      publicKey = parse(publicKeyFile);
    }
    if (privateKeyFile != null) {
      privateKey = parse(privateKeyFile);
    }
  }

  //生成公匙 和 私匙，默认1024。
  static List<String> generateKeys([int bits = 1024]) {
    var rnd = getSecureRandom();
    var rsaPars = RSAKeyGeneratorParameters(BigInt.parse("65537"), bits, 64);
    var params = ParametersWithRandom(rsaPars, rnd);

    var keyGenerator = KeyGenerator("RSA");
    keyGenerator.init(params);

    AsymmetricKeyPair<PublicKey, PrivateKey> keyPair =
    keyGenerator.generateKeyPair();
    RSAPrivateKey privateKey = keyPair.privateKey;
    RSAPublicKey publicKey = keyPair.publicKey;

    var pubKey = encodePublicKeyToPemPKCS1(publicKey);

    var priKey = encodePrivateKeyToPemPKCS1(privateKey);

    return [pubKey, priKey];
  }

  ///RSA公钥加密
  // ignore: missing_return
  Uint8List encryptByPublicKey(Uint8List data) {
    try {
      var keyParameter = () => PublicKeyParameter<RSAPublicKey>(publicKey);
      AsymmetricBlockCipher cipher = AsymmetricBlockCipher("RSA/PKCS1");
      cipher.reset();
      cipher.init(true, keyParameter());
      int index = 0;
      int stringLength = data.length;
      final keySize = publicKey.modulus.bitLength ~/ 8 - 11;
      final blockSize = publicKey.modulus.bitLength ~/ 8;
      final numBlocks =
        (stringLength ~/ keySize) + ((stringLength % keySize != 0) ? 1 : 0);
      Uint8List list = Uint8List(blockSize * numBlocks);
      int count = 0;
      while (index < stringLength) {
        Uint8List listTmp;
        if (index + keySize > stringLength) {
          listTmp = data.sublist(index, stringLength);
          index = stringLength;
        } else {
          listTmp = data.sublist(index, index + keySize);
          index += keySize;
        }
        Uint8List encryptResult = cipher.process(listTmp);
        for (int vI = 0; vI < blockSize; vI++) {
          list[count * blockSize + vI] = encryptResult[vI];
        }
        count += 1;
      }
      return list;
    } catch (e) {
      print(e.toString());
    }
  }

  ///RSA私钥加密
  // ignore: missing_return
  Uint8List encryptByPrivateKey(Uint8List data) {
    try {
      var keyParameter = () => PrivateKeyParameter<RSAPrivateKey>(privateKey);
      AsymmetricBlockCipher cipher = AsymmetricBlockCipher("RSA/PKCS1");
      cipher.reset();
      cipher.init(true, keyParameter());
      int index = 0;
      int stringLength = data.length;
      final keySize = publicKey.modulus.bitLength ~/ 8 - 11;
      final blockSize = publicKey.modulus.bitLength ~/ 8;
      final numBlocks =
        (stringLength ~/ keySize) + ((stringLength % keySize != 0) ? 1 : 0);
      Uint8List list = Uint8List(blockSize * numBlocks);
      int count = 0;
      while (index < stringLength) {
        Uint8List listTmp;
        if (index + keySize > stringLength) {
          listTmp = data.sublist(index, stringLength);
          index = stringLength;
        } else {
          listTmp = data.sublist(index, index + keySize);
          index += keySize;
        }
        Uint8List encryptResult = cipher.process(listTmp);
        for (int vI = 0; vI < blockSize; vI++) {
          list[count * blockSize + vI] = encryptResult[vI];
        }
        count += 1;
      }
      return list;
    } catch (e) {
      print("Encrypt By Private Key Error: ${e.toString()}");
    }
  }

  ///RSA公钥解密
  // ignore: missing_return
  Uint8List decryptByPublicKey(Uint8List data) {
    try {
      var keyParameter = () => PublicKeyParameter<RSAPublicKey>(publicKey);
      AsymmetricBlockCipher cipher = AsymmetricBlockCipher("RSA/PKCS1");

      cipher.reset();
      cipher.init(false, keyParameter());
      int index = 0;
      int stringLength = data.length;
      final keySize = publicKey.modulus.bitLength ~/ 8 - 11;
      final blockSize = publicKey.modulus.bitLength ~/ 8;
      final numBlocks = stringLength ~/ blockSize;
      Uint8List list = Uint8List(keySize * numBlocks);
      int count = 0;
      int stringIndex = 0;
      while (index < stringLength) {
        Uint8List listTmp =
        data.sublist(count * blockSize, (count + 1) * blockSize);
        Uint8List encryptResult = cipher.process(listTmp);
        for (int vI = 0; vI < encryptResult.length; vI++) {
          list[count * keySize + vI] = encryptResult[vI];
        }
        count += 1;
        stringIndex += encryptResult.length;
        index += blockSize;
      }
      return list.sublist(0, stringIndex);
    } catch (e) {
      print(e.toString());
    }
  }

  ///RSA私钥解密
  // ignore: missing_return
  Uint8List decryptByPrivateKey(Uint8List data) {
    try {
      var keyParameter = () => PrivateKeyParameter<RSAPrivateKey>(privateKey);
      AsymmetricBlockCipher cipher = AsymmetricBlockCipher("RSA/PKCS1");
      cipher.reset();
      cipher.init(false, keyParameter());
      int index = 0;
      int stringLength = data.length;
      final keySize = publicKey.modulus.bitLength ~/ 8 - 11;
      final blockSize = publicKey.modulus.bitLength ~/ 8;
      final numBlocks = stringLength ~/ blockSize;
      Uint8List list = Uint8List(keySize * numBlocks);
      int count = 0;
      int stringIndex = 0;
      while (index < stringLength) {
        Uint8List listTmp =
        data.sublist(count * blockSize, (count + 1) * blockSize);
        Uint8List encryptResult = cipher.process(listTmp);
        for (int vI = 0; vI < encryptResult.length; vI++) {
          list[count * keySize + vI] = encryptResult[vI];
        }
        count += 1;
        stringIndex += encryptResult.length;
        index += blockSize;
      }
      return list.sublist(0, stringIndex);
    } catch (e) {
      print(e.toString());
    }
  }

  static SecureRandom getSecureRandom() {
    var secureRandom = FortunaRandom();
    var random = Random.secure();
    List<int> seeds = [];
    for (int i = 0; i < 32; i++) {
      seeds.add(random.nextInt(255));
    }
    secureRandom.seed(new KeyParameter(new Uint8List.fromList(seeds)));
    return secureRandom;
  }

  static String encodePublicKeyToPemPKCS1(RSAPublicKey publicKey) {
    var topLevel = ASN1Sequence();

    topLevel.add(ASN1Integer(publicKey.modulus));
    topLevel.add(ASN1Integer(publicKey.exponent));

    var dataBase64 = base64.encode(topLevel.encodedBytes);
    return """-----BEGIN RSA PUBLIC KEY-----\n$dataBase64\n-----END RSA PUBLIC KEY-----""";
  }

  static String encodePrivateKeyToPemPKCS1(RSAPrivateKey privateKey) {
    var topLevel = ASN1Sequence();

    var version = ASN1Integer(BigInt.from(0));
    var modulus = ASN1Integer(privateKey.n);
    var publicExponent = ASN1Integer(privateKey.exponent);
    var privateExponent = ASN1Integer(privateKey.d);
    var p = ASN1Integer(privateKey.p);
    var q = ASN1Integer(privateKey.q);
    var dP = privateKey.d % (privateKey.p - BigInt.from(1));
    var exp1 = ASN1Integer(dP);
    var dQ = privateKey.d % (privateKey.q - BigInt.from(1));
    var exp2 = ASN1Integer(dQ);
    var iQ = privateKey.q.modInverse(privateKey.p);
    var co = ASN1Integer(iQ);

    topLevel.add(version);
    topLevel.add(modulus);
    topLevel.add(publicExponent);
    topLevel.add(privateExponent);
    topLevel.add(p);
    topLevel.add(q);
    topLevel.add(exp1);
    topLevel.add(exp2);
    topLevel.add(co);

    var dataBase64 = base64.encode(topLevel.encodedBytes);

    return """-----BEGIN RSA PRIVATE KEY-----\n$dataBase64\n-----END RSA PRIVATE KEY-----""";
  }

  ///解析PEM证书生成RSA密钥
  RSAAsymmetricKey parse(String key) {
    final rows = key.split('\n'); // LF-only, this could be a problem
    final header = rows.first;
    if (header == '-----BEGIN RSA PUBLIC KEY-----') {
      return _parsePublic(_parseSequence(rows));
    }

    if (header == '-----BEGIN PUBLIC KEY-----') {
      return _parsePublic(_pkcs8PublicSequence(_parseSequence(rows)));
    }

    if (header == '-----BEGIN RSA PRIVATE KEY-----') {
      return _parsePrivate(_parseSequence(rows));
    }

    if (header == '-----BEGIN PRIVATE KEY-----') {
      return _parsePrivate(_pkcs8PrivateSequence(_parseSequence(rows)));
    }
    // NOTE: Should we throw an exception?
    return null;
  }

  RSAAsymmetricKey _parsePublic(ASN1Sequence sequence) {
    final modulus = (sequence.elements[0] as ASN1Integer).valueAsBigInteger;
    final exponent = (sequence.elements[1] as ASN1Integer).valueAsBigInteger;

    return RSAPublicKey(modulus, exponent);
  }

  RSAAsymmetricKey _parsePrivate(ASN1Sequence sequence) {
    final modulus = (sequence.elements[1] as ASN1Integer).valueAsBigInteger;
    final exponent = (sequence.elements[3] as ASN1Integer).valueAsBigInteger;
    final p = (sequence.elements[4] as ASN1Integer).valueAsBigInteger;
    final q = (sequence.elements[5] as ASN1Integer).valueAsBigInteger;

    return RSAPrivateKey(modulus, exponent, p, q);
  }

  ASN1Sequence _parseSequence(List<String> rows) {
    final keyText = rows
      .skipWhile((row) => row.startsWith('-----BEGIN'))
      .takeWhile((row) => !row.startsWith('-----END'))
      .map((row) => row.trim())
      .join('');

    final keyBytes = Uint8List.fromList(base64.decode(keyText));
    final asn1Parser = ASN1Parser(keyBytes);

    return asn1Parser.nextObject() as ASN1Sequence;
  }

  ASN1Sequence _pkcs8PublicSequence(ASN1Sequence sequence) {
    final ASN1BitString bitString = sequence.elements[1];
    final bytes = bitString.valueBytes().sublist(1);
    final parser = ASN1Parser(Uint8List.fromList(bytes));

    return parser.nextObject() as ASN1Sequence;
  }

  ASN1Sequence _pkcs8PrivateSequence(ASN1Sequence sequence) {
    final bitString = sequence.elements[2];
    final bytes = bitString.valueBytes();
    final parser = ASN1Parser(bytes);

    return parser.nextObject() as ASN1Sequence;
  }
}
