import 'package:flutter/material.dart';

import 'package:zonamotora/widgets/plantilla_base.dart';
import 'package:zonamotora/widgets/secciones_page_base.dart';

class AutosIndexPage extends StatefulWidget {
  @override
  _AutosIndexPageState createState() => _AutosIndexPageState();
}

class _AutosIndexPageState extends State<AutosIndexPage> {


  @override
  Widget build(BuildContext context) {

    return PlantillaBase(
      pagInf: 1,
      context: context,
      activarIconInf: true,
      isIndex: false,
      child: _body(),
    );
  }

  ///
  Widget _body() {

    return SeccionesPageBase(
      currentSeccion: 2,
      showResultados: true,
      setLastPage: 'autos_index_page',
      hasHeadAdicional: false,
    );
  }
}