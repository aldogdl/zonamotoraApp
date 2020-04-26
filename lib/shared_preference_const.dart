library zonamotora.sp_const;

/*
 * Utilizado para verificar si se muestra la pagina de
 * Bienvenida al inicio de la App
 * 
 * @see  indexPage::_checkPageWelcome  -> Asignando
 * @see  indexPage::_checkPageWelcome  -> Consumido
*/
const String sp_showWelcome = 'showWelcome';

/*
 * Utilizado solo en desarrollo, evita que se dupliquen los hilos
 * de la configuración para PUSH
 * 
 * @see  init_config_page::_checkConfigPush  -> Asignando
 * @see  init_config_page::_checkConfigPush  -> Consumen
*/
const String sp_devClv = 'devClv';

/*
 * Utilizado para saber si el usuario acepta recibir notificaciones
 * 
 * @see  init_config_page::_initConfig       -> Consumen
 * @see  init_config_page::_checkConfigPush  -> Asignan
 * @see  registro_user_page::_sendForm       -> Asignan
 * @see  RecoveryCuentaPage::_getTokens      -> Asignan
*/
const String sp_notif = 'notiff';

/*
 * Utilizado para saber si el usuario ya vio la pagina de presentación "Ayuda"
 * en la página de registro de autos
 * 
 * @see  mis_autos_page::_queVerInicialmente         -> Asignan | Consume
 * @see  mis_autos_page::_accionEntendidoHelpPages   -> Asignan
*/
const String sp_isViewAutos = 'isVistaHelpInPageAutos';

/*
 * Utilizado para saber si el usuario ya vio la pagina de presentación "Ayuda"
 * en la página de registro de autos
 * 
 * @see  RecoveryCuentaPage::_getTokens              -> Asignan
 * @see  InitConfigPage::_checkDataUser              -> Asignan | Consume
*/
const String sp_updateTokenServerAt = 'updateTokenServerAt';
