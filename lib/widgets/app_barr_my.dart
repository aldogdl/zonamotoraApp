import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zonamotora/data_shared.dart';
import 'package:zonamotora/widgets/ico_notif_widget.dart';

class AppBarrMy {

  BuildContext _context;

  void setContext(BuildContext context) {
    this._context = context;
  }

  Widget getAppBarr({String titulo = 'ZonaMotora'}) {
    return AppBar(
      backgroundColor: Color(0xff7C0000),
      title: Text(
        '$titulo',
        textScaleFactor: 1,
        style: TextStyle(
          fontSize: 16
        ),
      ),
      elevation: 0,
      actions: <Widget>[
        Consumer<DataShared>(
          builder: (BuildContext _context, dataShared, _){
            if(dataShared.showNotif){
              return IcoNotifWidget();
            }else{
              return SizedBox(height: 30);
            }
          },
        )
      ],
    );
  }

  /* */
  Widget getAppBarrSliver({String titulo = 'ZonaMotora', Widget bgContent}) {

    return SliverAppBar(
      backgroundColor: const Color(0xff7C0000),
      expandedHeight: MediaQuery.of(this._context).size.height * 0.36,
      elevation: 2.0,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          '$titulo',
          textScaleFactor: 1,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: (MediaQuery.of(this._context).size.height <= 550) ? 14 : 16,
            shadows: [
              BoxShadow(
                blurRadius: 1,
                offset: Offset(1, 2),
                color: Colors.black
              )
            ]
          ),
        ),
        centerTitle: true,
        background: bgContent,
      ),
    );
  }

}
