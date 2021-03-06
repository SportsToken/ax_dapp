import 'package:ax_dapp/service/controller/token.dart';
import 'package:flutter/material.dart';

class USDC extends Token {
  USDC(String name, String ticker, [AssetImage? icon])
      : super(name, ticker, polygonAddress) {
    if (icon != null) {
      super.icon = icon;
    }
  }

  static String polygonAddress = '0x2791Bca1f2de4661ED88A30C99A7a9449Aa84174';
  static String sxAddress = '0x0000000000000000000000000000000000000000';
}
