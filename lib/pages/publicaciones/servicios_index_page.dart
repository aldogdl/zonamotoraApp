import 'package:flutter/material.dart';

import 'package:zonamotora/widgets/plantilla_base.dart';
import 'package:zonamotora/widgets/secciones_page_base.dart';

class PubsServiciosIndexPage extends StatefulWidget {
  @override
  _PubsServiciosIndexPageState createState() => _PubsServiciosIndexPageState();
}

class _PubsServiciosIndexPageState extends State<PubsServiciosIndexPage> {

  @override
  Widget build(BuildContext context) {

    return PlantillaBase(
      pagInf: 2,
      context: context,
      activarIconInf: true,
      isIndex: false,
      child: _body(),
    );
  }

  ///
  Widget _body() {
    
    return SeccionesPageBase(
      currentSeccion: 3,
      showResultados: true,
      setLastPage: 'servs_index_page',
      hasHeadAdicional: false,
    );
  }
}