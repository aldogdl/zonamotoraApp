import 'package:flutter/material.dart';

import 'package:zonamotora/pages/altas/alta_index_menu_page.dart';
import 'package:zonamotora/pages/altas/alta_mksmds_page.dart';
import 'package:zonamotora/pages/altas/alta_pagina_web_build_page.dart';
import 'package:zonamotora/pages/altas/alta_pagina_web_busk_user_page.dart';
import 'package:zonamotora/pages/altas/alta_pagina_web_carrucel_page.dart';
import 'package:zonamotora/pages/altas/alta_pagina_web_despeq_page.dart';
import 'package:zonamotora/pages/altas/alta_pagina_web_logo_page.dart';
import 'package:zonamotora/pages/altas/alta_perfil_contac_page.dart';
import 'package:zonamotora/pages/altas/alta_perfil_otros_page.dart';
import 'package:zonamotora/pages/altas/alta_perfil_pwrs_page.dart';
import 'package:zonamotora/pages/altas/alta_save_resum_page.dart';
import 'package:zonamotora/pages/altas/alta_sistema_page.dart';
import 'package:zonamotora/pages/altas/alta_sistema_palclas_page.dart';
import 'package:zonamotora/pages/altas/lista_users_page.dart';
import 'package:zonamotora/pages/notificaciones/notificaciones_page.dart';
import 'package:zonamotora/pages/pubs_autos/autos_index_page.dart';
import 'package:zonamotora/pages/pubs_autos/favs_autos_index_page.dart';
import 'package:zonamotora/pages/pubs_refacs/favs_refacs_index_page.dart';
import 'package:zonamotora/pages/pubs_refacs/refacs_index_page.dart';
import 'package:zonamotora/pages/pubs_servicios/favs_servicios_index_page.dart';
import 'package:zonamotora/pages/pubs_servicios/servicios_index_page.dart';
import 'package:zonamotora/pages/comprar/comprar_index_page.dart';
import 'package:zonamotora/pages/config/config_page.dart';
import 'package:zonamotora/pages/config/prba_push.dart';
import 'package:zonamotora/pages/constraint_push/constraint_push_page.dart';
import 'package:zonamotora/pages/cotizaciones/index_cotiza_page.dart';
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
import 'package:zonamotora/pages/oportunidades/fin_msg_cot_page.dart';
import 'package:zonamotora/pages/oportunidades/oportunidadesPage.dart';
import 'package:zonamotora/pages/oportunidades/send_fotos_cot_page.dart';
import 'package:zonamotora/pages/oportunidades/set_fotos_cotizacion_page.dart';
import 'package:zonamotora/pages/publicar/publicar_page.dart';
import 'package:zonamotora/pages/solicitudes/alta_pieza_page.dart';
import 'package:zonamotora/pages/solicitudes/add_autos_page.dart';
import 'package:zonamotora/pages/solicitudes/fin_solicitud_page.dart';
import 'package:zonamotora/pages/solicitudes/lst_modelos_select_page.dart';
import 'package:zonamotora/pages/solicitudes/lst_piezas_page.dart';
import 'package:zonamotora/pages/solicitudes/grax_por_solicitud_page.dart';

class Rutas {

  Map<String, Widget Function(BuildContext)> getRutas(BuildContext context) {

    return {
      'init_config_page'       : (context) => InitConfigPage(),
      'index_page'             : (context) => IndexPage(),
      'config_page'            : (context) => ConfigPage(),
      'prba_push'              : (context) => PrbaPush(),
      'autos_index_page'       : (context) => AutosIndexPage(),
      'refac_index_page'       : (context) => PubsRefacsIndexPage(),
      'servs_index_page'       : (context) => PubsServiciosIndexPage(),
      'favs_autos_index_page'  : (context) => FavsAutosIndexPage(),
      'favs_refac_index_page'  : (context) => FavsPubsRefacsIndexPage(),
      'favs_servs_index_page'  : (context) => FavsPubsServiciosIndexPage(),
      'notificaciones_page'    : (context) => NotificacionesPage(),
      'recovery_cuenta_page'   : (context) => RecoveryCuentaPage(),
      'login_asesor_page'      : (context) => LoginAsesorPage(),

      'login_page'             : (context) => LoginPage(),
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
      'alta_pagina_web_bsk_page': (context) => AltaPaginaWebBuskUserPage(),
      'alta_pagina_web_despeq_page':(context) => AltaPaginaWebDesPeqPage(),
      'alta_pagina_web_carrucel_page':(context) => AltaPaginaWebCarrucelPage(),
      'alta_pagina_web_build_page':(context) => AltaPaginaWebBuildPage(),
      'alta_pagina_web_logo_page':(context) => AltaPaginaWebLogoPage(),

      'add_autos_page'         : (context) => AddAutosPage(),
      'alta_piezas_page'       : (context) => AltaPiezasPage(),
      'lst_piezas_page'        : (context) => LstPiezasPage(),
      'lst_modelos_select_page': (context) => LstModelosSelectPage(),
      'fin_solicitud_page'     : (context) => FinSolicitudPage(),
      'grax_por_solicitud_page': (context) => GraxPorSolicitudPage(),

      'index_cotizacion_page'  : (context) => IndexCotizaPage(),
      'constraint_page_push'   : (context) => ConstraintPushPage(),
      'comprar_index_page'     : (context) => ComprarIndexPage(),

      'mis_autos_page'         : (context) => MisAutosPage(),

      'oportunidades_page'     : (context) => OportunidadesPage(),
      'crear_cotizacion_page'  : (context) => CrearCotizacionPage(),
      'set_fotos_cotizacion'   : (context) => SetfotosToCotizacionPage(),
      'send_fotos_cotizacion'  : (context) => SendFotosCotPage(),
      'fin_msg_cotizacion'     : (context) => FinMsgCotPage(),

      'publicar_page'          : (context) => PublicarPage()
    };
  }
}