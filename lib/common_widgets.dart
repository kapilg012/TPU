import 'package:flutter/material.dart';
import 'dimen.dart';

//Logger logger = getIt.get<Logger>();
get spacingVerticalSmall => const SizedBox(
      height: Spacing.small,
    );

get spacingVerticalNormal => const SizedBox(
      height: Spacing.normal,
    );

get spacingVerticalXSmall => const SizedBox(
      height: Spacing.xSmall,
    );

get spacingVerticalXxSmall => const SizedBox(
      height: Spacing.xxSmall,
    );

get spacingVerticalXxxSmall => const SizedBox(
      height: Spacing.xxxSmall,
    );

get spacingVerticalExtraMargin => const SizedBox(
      height: Spacing.extraMarginWidth,
    );

get spacingVerticalXLarge => const SizedBox(
      height: Spacing.xLarge,
    );

get spacingVerticalJUMBO30 => const SizedBox(
      height: Spacing.JUMBO30,
    );

get spacingVerticalExtraWidth => const SizedBox(
      height: Spacing.extraWidth,
    );

get spacingVerticalJUMBO50 => const SizedBox(
      height: Spacing.JUMBO50,
    );

get spacingVerticalJUMBO60 => const SizedBox(
      height: Spacing.JUMBO60,
    );

get spacingVerticalJUMBO40 => const SizedBox(
      height: Spacing.JUMBO40,
    );

get spacingVerticalJUMBO80 => const SizedBox(
      height: Spacing.JUMBO80,
    );

get spacingVerticalJUMBO90 => const SizedBox(
      height: Spacing.JUMBO90,
    );

get spacingVerticalXXLarge => const SizedBox(
      height: Spacing.xxLarge,
    );

get spacingVerticalXXXLarge => const SizedBox(
      height: Spacing.xxxLarge,
    );

get spacingVerticalLarge => const SizedBox(
      height: Spacing.large,
    );

get spacingVerticalSpace10 => const SizedBox(
      height: Spacing.space10,
    );

get spacingHorizontalSmall => const SizedBox(
      width: Spacing.small,
    );

get spacingHorizontalNormal => const SizedBox(
      width: Spacing.normal,
    );

get spacingHorizontalXSmall => const SizedBox(
      width: Spacing.xSmall,
    );

get spacingHorizontalXxSmall => const SizedBox(
      width: Spacing.xxSmall,
    );

get spacingHorizontalXxxSmall => const SizedBox(
      width: Spacing.xxxSmall,
    );

get spacingHorizontalXLarge => const SizedBox(
      width: Spacing.xLarge,
    );

get spacingHorizontalXxLarge => const SizedBox(
      width: Spacing.xxLarge,
    );

get spacingHorizontalXxxLarge => const SizedBox(
      width: Spacing.xxxLarge,
    );

get spacingVerticalXxxLarge => const SizedBox(
      height: Spacing.xxxLarge,
    );

get spacingHorizontalLarge => const SizedBox(
      width: Spacing.large,
    );

get spacingHorizontalSpace5 => const SizedBox(
      width: Spacing.space5,
    );

get spacingHorizontalSpace10 => const SizedBox(
      width: Spacing.space10,
    );

Widget circularScreenLoader() {
  return const Center(
    child: Padding(
      padding: EdgeInsets.all(8.0),
      child: CircularProgressIndicator(
        backgroundColor: Colors.white,
      ),
    ),
  );
}
