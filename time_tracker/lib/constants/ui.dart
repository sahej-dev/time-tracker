import 'package:flutter/material.dart';

const double kDefaultPadding = 16;
const double kDefaultIconSize = 24;
const double kDefaultBorderRadius = 12;

const double kDefaultDisableOpacity = 0.3;

const SliverGridDelegate kDefaultMobileGridDelegate =
    SliverGridDelegateWithFixedCrossAxisCount(
  crossAxisCount: 3,
  crossAxisSpacing: kDefaultPadding * 0.5,
  mainAxisSpacing: kDefaultPadding * 0.5,
);

const SliverGridDelegate kDefaultDesktopGridDelegate =
    SliverGridDelegateWithMaxCrossAxisExtent(
  maxCrossAxisExtent: 128,
  crossAxisSpacing: kDefaultPadding * 0.5,
  mainAxisSpacing: kDefaultPadding * 0.5,
);

const SliverGridDelegate kMobileActivityChooserGridDelegate =
    SliverGridDelegateWithFixedCrossAxisCount(
  crossAxisCount: 4,
  crossAxisSpacing: kDefaultPadding * 0.33,
  mainAxisSpacing: kDefaultPadding * 0.33,
);

const SliverGridDelegate kDesktopActivityChooserGridDelegate =
    SliverGridDelegateWithMaxCrossAxisExtent(
  maxCrossAxisExtent: 96,
  crossAxisSpacing: kDefaultPadding * 0.33,
  mainAxisSpacing: kDefaultPadding * 0.33,
);
