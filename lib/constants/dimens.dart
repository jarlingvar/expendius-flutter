import 'package:flutter/material.dart';

class PaddingDimens {
  static const mainHorizontal = 16.0;
  static const mainVertical = 8.0;
  static const secondaryHorizontal = 8.0;
  static const secondaryVertical = 4.0;
}

const mainPadding = EdgeInsets.symmetric(
    horizontal: PaddingDimens.mainHorizontal,
    vertical: PaddingDimens.mainVertical);
const mainPaddingHorizontal =
    EdgeInsets.symmetric(horizontal: PaddingDimens.mainHorizontal);
const mainPaddingVertical =
    EdgeInsets.symmetric(vertical: PaddingDimens.mainVertical);
const secondaryPadding = EdgeInsets.symmetric(
    horizontal: PaddingDimens.secondaryHorizontal,
    vertical: PaddingDimens.secondaryVertical);

class Sizes {
  static const p4 = 4.0;
  static const p8 = 8.0;
  static const p12 = 12.0;
  static const p16 = 16.0;
  static const p20 = 20.0;
  static const p24 = 24.0;
}

const gapW4 = SizedBox(width: Sizes.p4);
const gapW8 = SizedBox(width: Sizes.p8);
const gapW12 = SizedBox(width: Sizes.p12);
const gapW16 = SizedBox(width: Sizes.p16);
const gapW20 = SizedBox(width: Sizes.p20);
const gapW24 = SizedBox(width: Sizes.p24);

const gapH4 = SizedBox(height: Sizes.p4);
const gapH8 = SizedBox(height: Sizes.p8);
const gapH12 = SizedBox(height: Sizes.p12);
const gapH16 = SizedBox(height: Sizes.p16);
const gapH20 = SizedBox(height: Sizes.p20);
const gapH24 = SizedBox(height: Sizes.p24);
