import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:provider/provider.dart';
import 'package:zonamotora/data_shared.dart';
import 'package:zonamotora/repository/procc_roto_repository.dart';
import 'package:zonamotora/singletons/tomar_imagenes_sngt.dart';
import 'package:zonamotora/widgets/alerts_varios.dart';

class TomarImagenWidget extends StatelessWidget {
  
  final AlertsVarios alertsVarios = AlertsVarios();
  final TomarImagenesSngt tomarImagenesSngt = TomarImagenesSngt();
  final ProccRotoRepository emProcRoto = ProccRotoRepository();

  final Widget child;
  final _picker = ImagePicker();
  final String actionBarTitle;
  final int maxImages;
  final String restringirPosition = 'all';
  final BuildContext contextFrom;

  TomarImagenWidget({Key key, this.contextFrom, this.child, this.actionBarTitle, this.maxImages}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    int sumaRefresh = Provider.of<DataShared>(this.contextFrom, listen: false).refreshWidget;

    return InkWell(
      child: this.child,
      onTap: () async {

        bool fromFoto = await _alertGetFotoFrom();
        if(fromFoto != null){

          if(fromFoto) {
            tomarImagenesSngt.proccRoto['metadata']['source'] = 'camara';
            await emProcRoto.makeBackupGral(
              nameBackup: tomarImagenesSngt.proccRoto['nombre'],
              metadata: tomarImagenesSngt.proccRoto['metadata'],
              contents: {'tokenAsesor':tomarImagenesSngt.proccRoto['contents']}
            );
            await _tomarFotoDesdeCamara(sumaRefresh);
          }else{
            await _loadImagenDesdeGaleria(sumaRefresh);
          }
        }
      },
    );
  }

  /* */
  Future<bool> _alertGetFotoFrom() {

    String body = '¿Desde donde deseas seleccionar la fotografia? desde...';
    return showDialog(
      barrierDismissible: true,
      context: this.contextFrom,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            'TOMANDO IMÁGEN',
            textScaleFactor: 1,
            style: TextStyle(
              color: Colors.green,
              fontWeight: FontWeight.bold
            ),
            textAlign: TextAlign.center,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(100)
                ),
                child: Center(
                  child: Container(
                    width: 95,
                    height: 95,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(95)
                    ),
                    child: Icon(Icons.camera, color: Colors.white, size: 90),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                '$body',
                textScaleFactor: 1,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 20
                ),
              )
            ],
          ),
          actions: <Widget>[
            Align(
              alignment: Alignment.center,
              child: RaisedButton.icon(
                icon: Icon(Icons.folder_special, color: Colors.amber, size: 30),
                color: Colors.black,
                textColor: Colors.blue[300],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)
                ),
                label: Text(
                  'GALERÍA',
                  textScaleFactor: 1,
                ),
                onPressed: () => Navigator.of(context).pop(false),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: RaisedButton.icon(
                icon: Icon(Icons.camera_enhance, color: Colors.yellow, size: 30),
                color: Colors.black,
                textColor: Colors.blue[300],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)
                ),
                label: Text(
                  'CÁMARA',
                  textScaleFactor: 1,
                ),
                onPressed: () => Navigator.of(context).pop(true),
              ),
            ),
          ],
        );
      }
    );
  }

  ///
  Future<void> _tomarFotoDesdeCamara(int sumaRefresh) async {

    try {
      int sumar = sumaRefresh + 1;
      Provider.of<DataShared>(this.contextFrom, listen: false).setRefreshWidget(sumar);
      tomarImagenesSngt.imagenFile = await this._picker.getImage(source: ImageSource.camera);
      tomarImagenesSngt.source = 'camara';
    } catch (e) {
      tomarImagenesSngt.error = e.toString();
    }
  }

  ///
  Future<void> _loadImagenDesdeGaleria(int sumaRefresh) async {

    bool seguir = false;
    List<Asset> resultList;
    
    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: this.maxImages,
        enableCamera: false,
        cupertinoOptions: CupertinoOptions(
          takePhotoIcon: "chat",
        ),
        materialOptions: MaterialOptions(
          actionBarTitle: this.actionBarTitle,
          allViewTitle:   "Todas las Fotos",
          selectionLimitReachedText: 'Haz llegado al limite',
          textOnNothingSelected: 'No se ha seleccionado nada',
          lightStatusBar: false,
          useDetailsView: false,
          startInAllView: true,
          autoCloseOnSelectionLimit: true,
          actionBarColor: "#7C0000",
          statusBarColor: "#7C0000",
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      tomarImagenesSngt.error = e.toString();
    }

    if(resultList != null){

      if(this.restringirPosition != 'all'){
        if(this.restringirPosition == 'h') {
          if(resultList.first.isLandscape) {
            seguir = true;
          }else{
            resultList = null;
            tomarImagenesSngt.error = 'La imagen debe ser Horizontal';
          }
        }else{
          if(resultList.first.isPortrait) {
            seguir = true;
          }else{
            resultList = null;
            tomarImagenesSngt.error = 'La imagen debe ser Vertical';
          }
        }
      }else{
        seguir = true;
      }

      if(seguir){
        int sumar = sumaRefresh + 1;
        Provider.of<DataShared>(this.contextFrom, listen: false).setRefreshWidget(sumar);
        tomarImagenesSngt.imagenAsset = (resultList.isNotEmpty) ? resultList.first : null;
        tomarImagenesSngt.source = 'galeria';
      }

    }
  }

}