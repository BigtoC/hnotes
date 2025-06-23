import "package:flutter_test/flutter_test.dart";
import "package:hnotes/infrastructure/blockchain/wallet_repository.dart";
import "package:hnotes/infrastructure/constants.dart";
import "package:mantrachain_dart_sdk/api.dart" as mantra;
import "package:cosmos_sdk/cosmos_sdk.dart";

void main() {
  group("WalletRepository", () {
    late WalletRepository walletRepository;

    setUp(() {
      walletRepository = WalletRepository();
    });

    group("_calculateFee", () {
      // Create a test-only method that exposes the private _calculateFee method
      Fee calculateFeeForTesting(
        String gasPriceStr,
        mantra.Simulate200ResponseGasInfo gasInfo,
      ) {
        return walletRepository.calculateFee(gasPriceStr, gasInfo);
      }

      test("should calculate fee with valid gas price and usage", () {
        // Arrange
        final gasPriceStr = "0.025";
        final gasInfo = mantra.Simulate200ResponseGasInfo(
          gasUsed: "100000",
          gasWanted: "150000",
        );

        // Act
        final fee = calculateFeeForTesting(gasPriceStr, gasInfo);

        // Assert
        expect(fee.gasLimit, BigInt.from(100000 * gasLimitMultiplier));
        expect(fee.amount.length, 1);
        expect(fee.amount[0].denom, feeDenom);

        expect(fee.amount[0].amount, BigInt.from(10000));
      });

      test("should use default gas when gasUsed is null", () {
        // Arrange
        final gasPriceStr = "0.025";
        final gasInfo = mantra.Simulate200ResponseGasInfo(
          gasUsed: null,
          gasWanted: "150000",
        );

        // Act
        final fee = calculateFeeForTesting(gasPriceStr, gasInfo);

        // Assert
        expect(
          fee.gasLimit,
          BigInt.from(int.parse(defaultGasUsed) * gasLimitMultiplier),
        );

        final expectedAmount = BigInt.from(
          double.parse(gasPriceStr) *
              gasLimitMultiplier *
              double.parse(defaultGasUsed) *
              gasLimitMultiplier,
        );
        expect(fee.amount[0].amount, expectedAmount);
      });

      test("should round down decimal places when calculating amounts", () {
        // Arrange
        final gasPriceStr = "0.01234";
        final gasInfo = mantra.Simulate200ResponseGasInfo(
          gasUsed: "123456",
          gasWanted: "200000",
        );

        // Act
        final fee = calculateFeeForTesting(gasPriceStr, gasInfo);

        // Assert
        // Check that the result is properly rounded with no decimal places
        final rawAmount =
            double.parse(gasPriceStr) *
            gasLimitMultiplier *
            double.parse(gasInfo.gasUsed!) *
            gasLimitMultiplier;
        final expectedAmount = BigInt.parse(rawAmount.floor().toString());
        expect(fee.amount[0].amount, expectedAmount);
        expect(fee.amount[0].amount, BigInt.from(6093));
      });

      test("should handle high gas values properly", () {
        // Arrange
        final gasPriceStr = "0.0001";
        final gasInfo = mantra.Simulate200ResponseGasInfo(
          gasUsed: "10000000", // 10 million gas
          gasWanted: "15000000",
        );

        // Act
        final fee = calculateFeeForTesting(gasPriceStr, gasInfo);

        // Assert
        expect(fee.gasLimit, BigInt.from(10000000 * gasLimitMultiplier));

        final expectedAmount = BigInt.from(4000);
        expect(fee.amount[0].amount, expectedAmount);
      });

      test("should handle string conversion for gas values", () {
        // Arrange
        final gasPriceStr = "0.05";
        final gasInfo = mantra.Simulate200ResponseGasInfo(
          gasUsed: "99999", // odd number to test rounding
          gasWanted: "100000",
        );

        // Act
        final fee = calculateFeeForTesting(gasPriceStr, gasInfo);

        final expectedGasLimit = BigInt.parse(
          (99999 * gasLimitMultiplier).toStringAsFixed(0),
        );
        expect(fee.gasLimit, expectedGasLimit);

        final expectedAmount = BigInt.parse(
          (0.05 * gasLimitMultiplier * 99999 * gasLimitMultiplier)
              .floor()
              .toString(),
        );
        expect(fee.amount[0].amount, expectedAmount);
      });
    });
  });
}
