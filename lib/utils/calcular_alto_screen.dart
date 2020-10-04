import 'package:flutter/material.dart';

class CalcularAltoScreen {

  BuildContext _context;

  setContext(BuildContext context) {
    this._context = context;
    context = null;
  }

  double get hGradient => MediaQuery.of(this._context).size.height * 0.5;
  double get hPosHead => MediaQuery.of(this._context).size.height * 0.04;
  double get hHead => MediaQuery.of(this._context).size.height * 0.1;
  double get hHeadAnonimo => MediaQuery.of(this._context).size.height * 0.08;

  double getTopBody(String isAnonimo) {
    double top = hPosHead + hHead;
    if(isAnonimo == 'Anónimo'){
      top = top + hHeadAnonimo;
    }
    return top;
  }

}