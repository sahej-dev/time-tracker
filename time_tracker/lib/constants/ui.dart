import 'package:flutter/material.dart';

const double kDefaultPadding = 16;
const double kDefaultIconSize = 24;
const double kDefaultBorderRadius = 12;

const SliverGridDelegate kDefaultGridDelegate =
    SliverGridDelegateWithFixedCrossAxisCount(
  crossAxisCount: 3,
  crossAxisSpacing: kDefaultPadding * 0.25,
  mainAxisSpacing: kDefaultPadding * 0.25,
);
