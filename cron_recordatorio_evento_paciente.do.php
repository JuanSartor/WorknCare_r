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

  $_REQUEST["cname"] = "common";
  //
  $_REQUEST["action"] = "1";
  $_REQUEST["modulo"] = "cron";
  $_REQUEST["submodulo"] = "recordatorio_evento_paciente";
  //

  require_once("xframework.php");
  
?>