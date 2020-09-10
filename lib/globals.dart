library zonamotora.globals;

const String env = 'dev';
const int devClvTmp = 0;
const String version = '1.0.0';

const String protocolo         = 'http://';
const String ip                = '192.168.0.28';
const String dominio           = '$protocolo$ip';
const String uriBase           = '$dominio/zmdb/public_html/index.php';
const String uripublicZmdb     = '$dominio/zmdb/public_html/';
const String uriImgSolicitudes = '$dominio/zmdb/public_html/solicitudes_nuevas/images';
const String uriImageInvent    = '$dominio/zmdb/public_html/images/refacciones';

// const String dominio           = 'dbzm.info';
// const String uriBase           = '$protocolo$dominio';
// const String uriImgSolicitudes = '$uriBase/solicitudes_nuevas/images';
// const String uriImageInvent    = '$uriBase/images/refacciones';

const String uriImgsAldo       = 'https://s3-us-west-2.amazonaws.com/aldoautopartesproductos';

const int tamMaxFotoPzas = 768;
const double iva = 16;
