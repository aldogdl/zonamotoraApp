import 'package:flutter/material.dart';
import 'package:zonamotora/widgets/compartir_pagweb_widget.dart';
import 'package:zonamotora/widgets/menu_dialog_alta_widget.dart';

MenuDialogAltaWidget mnuDialog = MenuDialogAltaWidget();

Widget widget(
  BuildContext context,
  String backTo,
  {
    Color colorTxt = Colors.redAccent,
    Color colorIcon = Colors.purple,
    bool showBtnMenualta = true,
    bool showBtnSharedPagWebs = false,
    List<Map<String, dynamic>> lstMenu
  }
  ) {

  return Container(
    width: MediaQuery.of(context).size.width,
    height: MediaQuery.of(context).size.height * 0.1,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget> [
        FlatButton.icon(
          label: Text(
            'REGRESAR',
            textScaleFactor: 1,
            style: TextStyle(
              color: colorTxt,
              fontSize: 17,
            ),
          ),
          icon: Icon(Icons.arrow_back, size: 30, color: colorIcon),
          onPressed: () {
            Navigator.of(context).pushNamedAndRemoveUntil(backTo, (Route rutas) => false);
          },
        ),
        (showBtnMenualta)
        ?
        IconButton(
          icon: Icon(Icons.clear_all, size: 30, color: colorIcon),
          onPressed: () async {
            await mnuDialog.showDialogMenu(context, lstMenu);
          },
        )
        :
        SizedBox(width: 0),
        (showBtnSharedPagWebs)
        ?
        CompartiPagWebWidget(contextFromCall: context)
        :
        SizedBox(width: 0)
      ],
    ),
  );
}