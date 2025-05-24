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
          String gasPriceStr, mantra.Simulate200ResponseGasInfo gasInfo
      ) {
        return walletRepository.calculateFee(gasPriceStr, gasInfo);
      }

      test("should calculate fee with valid gas price and usage", () {
        // Arrange
        final gasPriceStr = "0.025";
        final gasInfo = mantra.Simulate200ResponseGasInfo(
          gasUsed: "100000",
          gasWanted: "150000"
        );

        // Act
        final fee = calculateFeeForTesting(gasPriceStr, gasInfo);

        // Assert
        expect(fee.gasLimit, BigInt.from(100000 * gasLimitMultiplier));
        expect(fee.amount.length, 1);
        expect(fee.amount[0].denom, feeDenom);

        // Expected amount = gasPrice * gasLimit = 0.025 * (100000 * 3) = 7500
        expect(fee.amount[0].amount, BigInt.from(7500));
      });

      test("should use default gas when gasUsed is null", () {
        // Arrange
        final gasPriceStr = "0.025";
        final gasInfo = mantra.Simulate200ResponseGasInfo(
          gasUsed: null,
          gasWanted: "150000"
        );

        // Act
        final fee = calculateFeeForTesting(gasPriceStr, gasInfo);

        // Assert
        expect(fee.gasLimit, BigInt.from(
            int.parse(defaultGasUsed) * gasLimitMultiplier)
        );

        // Expected amount = gasPrice * gasLimit = 0.025 * (30000 * 1.5) = 1125
        // (assuming defaultGasUsed is '30000')
        final expectedAmount = BigInt.from(double.parse(gasPriceStr) *
                               double.parse(defaultGasUsed) *
                               gasLimitMultiplier);
        expect(fee.amount[0].amount, expectedAmount);
      });

      test("should round down decimal places when calculating amounts", () {
        // Arrange
        final gasPriceStr = "0.01234";
        final gasInfo = mantra.Simulate200ResponseGasInfo(
          gasUsed: "123456",
          gasWanted: "200000"
        );

        // Act
        final fee = calculateFeeForTesting(gasPriceStr, gasInfo);

        // Assert
        // Check that the result is properly rounded with no decimal places
        // Expected calculation: 0.01234 * (123456 * 3) = 4570
        // But should be truncated to 2285
        final rawAmount = double.parse(gasPriceStr) *
                        double.parse(gasInfo.gasUsed!) *
                        gasLimitMultiplier;
        final expectedAmount = BigInt.parse(rawAmount.toStringAsFixed(0));
        expect(fee.amount[0].amount, expectedAmount);
        expect(fee.amount[0].amount, BigInt.from(4570));
      });

      test("should handle high gas values properly", () {
        // Arrange
        final gasPriceStr = "0.0001";
        final gasInfo = mantra.Simulate200ResponseGasInfo(
          gasUsed: "10000000", // 10 million gas
          gasWanted: "15000000"
        );

        // Act
        final fee = calculateFeeForTesting(gasPriceStr, gasInfo);

        // Assert
        expect(fee.gasLimit, BigInt.from(10000000 * gasLimitMultiplier));

        // Expected amount = 0.0001 * (10000000 * 3) = 3000
        final expectedAmount = BigInt.from(3000);
        expect(fee.amount[0].amount, expectedAmount);
      });

      test("should handle string conversion for gas values", () {
        // Arrange
        final gasPriceStr = "0.05";
        final gasInfo = mantra.Simulate200ResponseGasInfo(
          gasUsed: "99999", // odd number to test rounding
          gasWanted: "100000"
        );

        // Act
        final fee = calculateFeeForTesting(gasPriceStr, gasInfo);

        // Assert
        // Expected gasLimit = 99999 * 1.5 = 149998.5, rounded to 149999
        final expectedGasLimit = BigInt.parse(
            (99999 * gasLimitMultiplier).toStringAsFixed(0)
        );
        expect(fee.gasLimit, expectedGasLimit);

        // Expected amount = 0.05 * 149999 = 7499.95, rounded to 7500
        final expectedAmount = BigInt.parse(
            (0.05 * 99999 * gasLimitMultiplier).toStringAsFixed(0)
        );
        expect(fee.amount[0].amount, expectedAmount);
      });
    });
  });
}
