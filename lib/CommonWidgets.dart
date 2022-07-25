/*

import 'package:one_context/one_context.dart';

import 'enums.dart';

//Logger logger = getIt.get<Logger>();

showCustomToast(
    {required String text, ToastType toastType = ToastType.Success}) {
  Color backgroundColor;

  switch (toastType) {
    case ToastType.Success:
      backgroundColor = KTBColor.lightGreenColor;
      break;
    case ToastType.Error:
      backgroundColor = Colors.red;
      break;
  }

  BotToast.showCustomText(
    toastBuilder: (CancelFunc cancel) => Align(
      alignment: Alignment.topCenter,
      child: Material(
        child: Container(
          color: backgroundColor,
          child: Row(
            children: [
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: Spacing.xSmall),
                child: Text(
                  text,
                  style: TextStyles.normalWhite,
                ),
              )),
              IconButton(
                onPressed: () => cancel(),
                icon: Icon(
                  Icons.close,
                  color: KTBColor.whiteColor,
                ),
              )
            ],
          ),
        ),
      ),
    ),
    duration:
        Duration(milliseconds: toastType == ToastType.Success ? 5000 : 1900),
    animationDuration: Duration(milliseconds: 300),
    onlyOne: true,
  );
}

bool handleAPIResponse(BaseModel? response, Function successTransaction,
    {Function? onFailed, shouldShowError = true}) {
  if (response != null) {
    if (response.status!) {
      successTransaction();
      return true;
    } else {
      if (onFailed != null) onFailed();
      if (!kDebugMode) return false;
      if (!shouldShowError) return false;
      try {
        Scaffold.of(OneContext.instance.key.currentContext!).showSnackBar(
            getSnackBar(response.message ?? StringResource.somethingWrong,
                isError: true));
      } catch (e) {
        showCustomToast(
            text: response.message ?? StringResource.somethingWrong,
            toastType: ToastType.Error);
      }
      return false;
    }
  } else {
    if (onFailed != null) onFailed();
    if (!kDebugMode) return false;
    if (!shouldShowError) return false;
    try {
      Scaffold.of(OneContext.instance.key.currentContext!).showSnackBar(
          getSnackBar(StringResource.somethingWrong, isError: true));
    } catch (e) {
      showCustomToast(
          text: response?.message ?? StringResource.somethingWrong,
          toastType: ToastType.Error);
    }
    return false;
  }
}

showSnackBar(message, {isError = false}) {
  ScaffoldMessenger.of(OneContext.instance.context!)
      .showSnackBar(getSnackBar(message, isError: isError));
}

getSnackBar(message, {isError = false}) {
  return SnackBar(
    content: Row(
      children: [
        Expanded(
            child: Text(
          message,
          // style: TextStyles.normalWhite,
        )),
      ],
    ),
    action: SnackBarAction(
      label: "Dismiss",
      onPressed: () => ScaffoldMessenger.of(OneContext.instance.context!)
          .hideCurrentSnackBar(),
      textColor: KTBColor.primary,
    ),
    backgroundColor: !isError ? KTBColor.textColor : KTBColor.deleteColor,
    duration: isError ? Duration(seconds: 2) : Duration(milliseconds: 1500),
  );
}

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

get spacingVerticalXLarge => const SizedBox(
      height: Spacing.xLarge,
    );

get spacingVerticalLarge => const SizedBox(
      height: Spacing.large,
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

get spacingHorizontalXLarge => const SizedBox(
      width: Spacing.xLarge,
    );

get spacingHorizontalLarge => const SizedBox(
      width: Spacing.large,
    );
*/
import 'package:flutter/material.dart';

import 'dimen.dart';

//Logger logger = getIt.get<Logger>();
get spacingVerticalSmall =>
    const SizedBox(
      height: Spacing.small,
    );

get spacingVerticalNormal =>
    const SizedBox(
      height: Spacing.normal,
    );

get spacingVerticalXSmall =>
    const SizedBox(
      height: Spacing.xSmall,
    );

get spacingVerticalXxSmall =>
    const SizedBox(
      height: Spacing.xxSmall,
    );

get spacingVerticalXxxSmall =>
    const SizedBox(
      height: Spacing.xxxSmall,
    );

get spacingVerticalExtraMargin =>
    const SizedBox(
      height: Spacing.extraMarginWidth,
    );

get spacingVerticalXLarge =>
    const SizedBox(
      height: Spacing.xLarge,
    );

get spacingVerticalJUMBO30 =>
    const SizedBox(
      height: Spacing.JUMBO30,
    );

get spacingVerticalExtraWidth =>
    const SizedBox(
      height: Spacing.extraWidth,
    );

get spacingVerticalJUMBO50 =>
    const SizedBox(
      height: Spacing.JUMBO50,
    );

get spacingVerticalJUMBO60 =>
    const SizedBox(
      height: Spacing.JUMBO60,
    );

get spacingVerticalJUMBO40 =>
    const SizedBox(
      height: Spacing.JUMBO40,
    );

get spacingVerticalJUMBO80 =>
    const SizedBox(
      height: Spacing.JUMBO80,
    );

get spacingVerticalJUMBO90 =>
    const SizedBox(
      height: Spacing.JUMBO90,
    );

get spacingVerticalXXLarge =>
    const SizedBox(
      height: Spacing.xxLarge,
    );

get spacingVerticalXXXLarge =>
    const SizedBox(
      height: Spacing.xxxLarge,
    );

get spacingVerticalLarge =>
    const SizedBox(
      height: Spacing.large,
    );

get spacingVerticalSpace10 =>
    const SizedBox(
      height: Spacing.space10,
    );

get spacingHorizontalSmall =>
    const SizedBox(
      width: Spacing.small,
    );

get spacingHorizontalNormal =>
    const SizedBox(
      width: Spacing.normal,
    );

get spacingHorizontalXSmall =>
    const SizedBox(
      width: Spacing.xSmall,
    );

get spacingHorizontalXxSmall =>
    const SizedBox(
      width: Spacing.xxSmall,
    );

get spacingHorizontalXxxSmall =>
    const SizedBox(
      width: Spacing.xxxSmall,
    );

get spacingHorizontalXLarge =>
    const SizedBox(
      width: Spacing.xLarge,
    );

get spacingHorizontalXxLarge =>
    const SizedBox(
      width: Spacing.xxLarge,
    );

get spacingHorizontalXxxLarge =>
    const SizedBox(
      width: Spacing.xxxLarge,
    );

get spacingVerticalXxxLarge =>
    const SizedBox(
      height: Spacing.xxxLarge,
    );

get spacingHorizontalLarge =>
    const SizedBox(
      width: Spacing.large,
    );
get spacingHorizontalSpace5 =>
    const SizedBox(
      width: Spacing.space5,
    );
get spacingHorizontalSpace10 =>
    const SizedBox(
      width: Spacing.space10,
    );

Widget circularScreenLoader() {
  return Center(
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: CircularProgressIndicator(
        backgroundColor: Colors.white,
      ),
    ),
  );
}

