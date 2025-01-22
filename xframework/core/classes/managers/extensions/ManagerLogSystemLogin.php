<?php

  require_once(path_libs("libs_php/geoip-api-php-master/src/geoip.inc"));

//  require_once(path_libs("libs_php/geoip-api-php-master/data/GeoIP.dat"));
  /**
   * 	Manager perteneeciente al log de los ingresos al sistema de los usuarios web
   *
   * 	@author Xinergia
   * 	@version 1.0
   * 	@package managers\extensions
   */
  class ManagerLogSystemLogin extends Manager {

      /** constructor
       * 	@param $db instancia de adodb
       */
      function __construct($db) {

          // Constructor
          parent::__construct($db, "logsystemlogin", "idlogSystemLogin");
      }

      
      /**
       * Método que procesa desde el login el log del usuario
       * @param type $request
       * @return type
       */
      public function processFromLogin($request) {

          $ip = $this->ObtenerIP();
//          $ip = '190.183.238.36';

          $gi = geoip_open(path_libs("libs_php/geoip-api-php-master/data/GeoIP.dat"), 0);

          $iso = geoip_country_code_by_addr($gi, $ip);

          return parent::process([
                "fecha" => date("Y-m-d H:i:s"),
                "ip" => $ip,
                "ISO" => $iso,
                "usuarioweb_idusuarioweb" => $request["idusuarioweb"],
                "usuario_prestador_idusuario_prestador" => $request["idusuario_prestador"]
          ]);
      }

      function ObtenerIP() {
          $ip = "";
          if (isset($_SERVER)) {
              if (!empty($_SERVER['HTTP_CLIENT_IP'])) {
                  $ip = $_SERVER['HTTP_CLIENT_IP'];
              } elseif (!empty($_SERVER['HTTP_X_FORWARDED_FOR'])) {
                  $ip = $_SERVER['HTTP_X_FORWARDED_FOR'];
              } else {
                  $ip = $_SERVER['REMOTE_ADDR'];
              }
          } else {
              if (getenv('HTTP_CLIENT_IP')) {
                  $ip = getenv('HTTP_CLIENT_IP');
              } elseif (getenv('HTTP_X_FORWARDED_FOR')) {
                  $ip = getenv('HTTP_X_FORWARDED_FOR');
              } else {
                  $ip = getenv('REMOTE_ADDR');
              }
          }
          // En algunos casos muy raros la ip es devuelta repetida dos veces separada por coma 
          if (strstr($ip, ',')) {
              $ip = array_shift(explode(',', $ip));
          }
          return $ip;
      }

  }

  //END_class
?>