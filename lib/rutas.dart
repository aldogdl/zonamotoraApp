import 'package:flutter/material.dart';

import 'package:zonamotora/pages/altas/alta_index_menu_page.dart';
import 'package:zonamotora/pages/altas/alta_mksmds_page.dart';
import 'package:zonamotora/pages/altas/alta_perfil_contac_page.dart';
import 'package:zonamotora/pages/altas/alta_perfil_otros_page.dart';
import 'package:zonamotora/pages/altas/alta_perfil_pwrs_page.dart';
import 'package:zonamotora/pages/altas/alta_save_resum_page.dart';
import 'package:zonamotora/pages/altas/alta_sistema_page.dart';
import 'package:zonamotora/pages/altas/alta_sistema_palclas_page.dart';
import 'package:zonamotora/pages/altas/lista_users_page.dart';
import 'package:zonamotora/pages/autos/autos_index_page.dart';
import 'package:zonamotora/pages/buscar/buscar_index_page.dart';
import 'package:zonamotora/pages/config/config_page.dart';
import 'package:zonamotora/pages/index/index_page.dart';
import 'package:zonamotora/pages/init_config/init_config_page.dart';
import 'package:zonamotora/pages/login/login_asesor_page.dart';
import 'package:zonamotora/pages/login/login_page.dart';
import 'package:zonamotora/pages/login/recovery_cuenta_page.dart';
import 'package:zonamotora/pages/login/registro_index.dart';
import 'package:zonamotora/pages/login/registro_prof_grax.dart';
import 'package:zonamotora/pages/login/registro_user_page.dart';
import 'package:zonamotora/pages/login/registro_prof_index.dart';
import 'package:zonamotora/pages/mis_autos/mis_autos_page.dart';
import 'package:zonamotora/pages/oportunidades/crear_cotizacion_page.dart';
import 'package:zonamotora/pages/oportunidades/oportunidadesPage.dart';
import 'package:zonamotora/pages/solicitudes/alta_pieza_page.dart';
import 'package:zonamotora/pages/solicitudes/add_autos_page.dart';
import 'package:zonamotora/pages/solicitudes/fin_solicitud_page.dart';
import 'package:zonamotora/pages/solicitudes/lst_modelos_select_page.dart';
import 'package:zonamotora/pages/solicitudes/lst_piezas_page.dart';
import 'package:zonamotora/pages/solicitudes/grax_por_solicitud_page.dart';
import 'package:zonamotora/widgets/seleccionar_anio_widget_page.dart';
import 'package:zonamotora/widgets/seleccionar_auto_widget_page.dart';

class Rutas {

  Map<String, Widget Function(BuildContext)> getRutas(BuildContext context) {

    return {
      'init_config_page'       : (context) => InitConfigPage(),
      'index_page'             : (context) => IndexPage(),
      'config_page'            : (context) => ConfigPage(),
      'autos_index_page'       : (context) => AutosIndexPage(),
      'login_page'             : (context) => LoginPage(),
      'recovery_cuenta_page'   : (context) => RecoveryCuentaPage(),
      'login_asesor_page'      : (context) => LoginAsesorPage(),

      'reg_index_page'         : (context) => RegistroIndexPage(),
      'reg_prof_index_page'    : (context) => RegistroProfIndex(),
      'reg_prof_grax_page'     : (context) => RegistroProfGraxPage(),
      'reg_user_page'          : (context) => RegistroUserPage(),

      'alta_index_menu_page'   : (context) => AltaIndexMenuPage(),
      'alta_lst_users_page'    : (context) => ListaUsersPage(),
      'alta_sistema_page'      : (context) => AltaSistemaPage(),
      'alta_sistema_pc_page'   : (context) => AltaSistemaPalClasPage(),
      'alta_mksmds_page'       : (context) => AltaMksMdsPage(),
      'alta_perfil_contac_page': (context) => AltaPerfilContacPage(),
      'alta_perfil_pwrs_page'  : (context) => AltaPerfilPWRSPage(),
      'alta_perfil_otros_page' : (context) => AltaPerfilOtrosPage(),
      'alta_save_resum_page'   : (context) => AltaSaveResumPage(),

      'add_autos_page'         : (context) => AddAutosPage(),
      'alta_piezas_page'       : (context) => AltaPiezasPage(),
      'lst_piezas_page'        : (context) => LstPiezasPage(),
      'lst_modelos_select_page': (context) => LstModelosSelectPage(),
      'fin_solicitud_page'     : (context) => FinSolicitudPage(),
      'grax_por_solicitud_page': (context) => GraxPorSolicitudPage(),

      'mis_autos_page'         : (context) => MisAutosPage(),
      'seleccionar_auto_page'  : (context) => SeleccionarAutoWidgetPage(),
      'seleccionar_anio_page'  : (context) => SeleccionarAnioWidgetPage(),

      'oportunidades_page'     : (context) => OportunidadesPage(),
      'crear_cotizacion_page'  : (context) => CrearCotizacionPage(),
      'buscar_index_page'      : (context) => BuscarIndexPage(),
    };
  }
}