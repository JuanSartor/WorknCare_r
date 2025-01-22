<?php

  /**
   * @author Sebastian Balestrini <sbalestrini@gmail.com>
   * @version 1.0
   *
   * Controlador central del Framework
   *
   */
  error_reporting(0);
//ini_set('display_errors','1');
 //error_reporting(6143);
  define("VIEW_DEBUG", FALSE);

if ($_SERVER["REMOTE_ADDR"] == "-5.180.63.206") {
    ini_set('display_errors', '1');
    error_reporting(6143);
    define("VIEW_DEBUG", true);
    define("DEBUG_DB", true);
    define("DEBUG_APP", true);
}
  $_REQUEST["cname"] = "frontend_2";

  require_once("xframework.php");
  
?>
