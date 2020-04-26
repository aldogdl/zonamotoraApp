import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zonamotora/data_shared.dart';
import 'package:zonamotora/widgets/menu_dialog_alta_widget.dart';

MenuDialogAltaWidget mnuDialog = MenuDialogAltaWidget();

Widget widget(
  BuildContext context,
  String titulo,
  {
    Color colorTxt = Colors.redAccent,
    Color colorIcon = Colors.purple,
    bool showBtnMenualta = true,
    List<Map<String, dynamic>> lstMenu
  }
  ) {

  return Container(
    width: MediaQuery.of(context).size.width,
    height: MediaQuery.of(context).size.height * 0.1,
    decoration: BoxDecoration(
      color: Colors.red[100],
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget> [
        FlatButton.icon(
          label: Text(
            titulo,
            textScaleFactor: 1,
            style: TextStyle(
              color: colorTxt,
              fontSize: 17
            ),
          ),
          icon: Icon(Icons.arrow_back, size: 30, color: colorIcon),
          onPressed: () {
            Navigator.of(context).pushNamedAndRemoveUntil(
              Provider.of<DataShared>(context, listen: false).lastPageVisit,
              (Route rutas) => false
            );
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
        SizedBox(width: 0)
      ],
    ),
  );
}