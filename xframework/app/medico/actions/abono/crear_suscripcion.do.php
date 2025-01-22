<?php

  /**
   * Action de crear una nueva suscripcion premium y obtener la preferencia de pago de MercadoPago
   */
  $this->start();

  $ManagerSuscripcionPremium = $this->getManager("ManagerSuscripcionPremium");
  $suscripcion = $ManagerSuscripcionPremium->nuevaSuscripcion();
  $this->finish($ManagerSuscripcionPremium->getMsg());

/*if($suscripcion){
   $result=$ManagerSuscripcionPremium->getMsg();
  $ManagerMetodoPago = $this->getManager("ManagerMetodoPago");

  $request = $this->request;
  $request["idsuscripcion"] = $result["id"];
  $request["cuotas"] = CANTIDAD_MESES_SUSCRIPCION;
  $request["monto"] = MONTO_CUOTA;
  //$request["email"] =  $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["user"]["email"];
  $request["email"] = "test_user_24182223@testuser.com";//usuario testing

  /*echo "<pre>";
  print_r ($_SESSION[URL_ROOT][CONTROLLER]['logged_account']["user"]["email"]);
  echo "</pre>";*/

  
 /* $preferencia = $ManagerMetodoPago->getEnlacePagoRecurrenteMP($request);
  
  $this->finish($ManagerMetodoPago->getMsg());
}else{
     $this->finish($ManagerSuscripcionPremium->getMsg());
}*/