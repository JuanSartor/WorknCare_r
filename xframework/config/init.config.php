<?php

/**
 * 	init.config.php
 * 	Archivo de configuraciones iniciales.
 *
 * 	@author Sebastian Balestrini <sbalestrini@gmail.com>
 * 	@version 3.0
 */
// Configuracion del servidor de Base de Datos	
define("DEBUG_DB", false);
define("DEBUG_APP", false);



//horas de caducidad para el reseteo del pass
define("RESET_PASS_TTL", 48);

// Nombre del sistema
define("NOMBRE_SISTEMA", "WorknCare");

//cantidad de meses dura la suscripcion
define("CANTIDAD_MESES_SUSCRIPCION", 6);

//precio de la cuota
define("MONTO_CUOTA",75);
define("THEME_ADMIN", "admin");


define('FIRSTKEY', 's1NixQMnD96IeS1SDQaqHq5O+uYGX2XWpVNjUDRQ/D8');
define('SECONDKEY', 'XYaMwf2+l0jskji+QeDqWzr7GSrkXVOAfgfQbdpXmTdlwXvHqvlZf3eUt8VE4ow7QEsgxm8ZtDsHCfLLUsEa5w==');

//constantes de videoconsulta

//constantes de videoconsulta
define("VIDEOCONSULTA_DURACION",180);
define("VIDEOCONSULTA_VENCIMIENTO_SALA",30);
define("VIDEOCONSULTA_HORAS_PENDIENTE_FINALIZACION",2400);
define("VENCIMIENTO_VC_FRECUENTES",48);
define("VENCIMIENTO_VC_RED",48);
define("VIDEOCONSULTA_NOTIFICAR_MEDICO_DEMORADO",1);

define("SERVER_EASYRTC_PORT", 9999);

//constantes consulta express - en horas

define("VENCIMIENTO_CE_FRECUENTES", 24);
define("VENCIMIENTO_CE_RED", 24);


//constanes precio
define("PRECIO_MINIMO_CE",0);
define("PRECIO_MINIMO_VC",10);
define("PRECIO_MINIMO_VC_TURNO",10);
define("PRECIO_MAXIMO_CE",15);
define("PRECIO_MAXIMO_VC",70);
define("PRECIO_MAXIMO_VC_TURNO",70);

//comisiones - procentaje
define("COMISION_CE",10);
define("COMISION_VC",10);

//constantes socket node js
define("SERVER_NODE_PORT",8000);

//constantes google captcha
define("RECAPTCHA_PUBLIC","6Ld-wa4ZAAAAAH6cQAjb_D41bvxiloxG-jzm71XT");
define("RECAPTCHA_SECRET","6Ld-wa4ZAAAAAL_CyYT2i279XRGds-vVSaNY4V5d");

//public key
define("ENCRYPT_KEY", "doctorplus");

//key de google maps
define("GOOGLE_MAPS_KEY", "AIzaSyAiAp4o4BqFlL2TbZgAtKEFfeW2L4e0L9U");
// define("GOOGLE_MAPS_KEY","AIzaSyAxK4DZwnXRsexwfiK0B292DDUMqHUXMtQ");
//cantidad de mails y sms enviados por el cron
define("CANTIDAD_ENVIO_MAIL_SIMULTANEOS", 50);
define("CANTIDAD_ENVIO_SMS_SIMULTANEOS", 50);



//Doctorplus
define("TOKBOX_API_KEY", 46322012);
define("TOKBOX_SECRET_KEY", '70b3291bb6b68ed0a6d17fe68ef9e80a279bd5f1');
//define("TOKBOX_API_KEY", 46544632);
//define("TOKBOX_SECRET_KEY", '04157dbacc53e37a49025db201f36cb3059d6034');



$server_ip = getHostByName(getHostName());

//KEYS STRIPE 
define("STRIPE_APIKEY_PUBLIC", "pk_live_htoQbtY1XalXXy4D9TgMovf4");
define("STRIPE_APIKEY_SECRET", "sk_live_PlrdYPf9b4NdPMoVVQ5Dlgeh");
define("STRIPE_ENDPOINT_SECRET", "whsec_QqYm0Ra0R6GwGyXYy9k495LW8dn8ugc3");
define("STRIPE_IDPLAN", "plan_FHwqmhA698Q5wk");//id plan de pago 50eur/mes




//configuracion de traduccion
define("IDIOMAS_TRADUCCION", "fr,en");
define("TRADUCCION_DEFAULT", "fr");

if (isset($_SESSION["translate"]) &&  $_SESSION["translate"] == false) {
    define("TRADUCIR_SISTEMA", false);
} else {
    define("TRADUCIR_SISTEMA", TRUE);
}

define("VERSION", "1.0");

if (function_exists('date_default_timezone_set'))
      date_default_timezone_set("Europe/Paris");
