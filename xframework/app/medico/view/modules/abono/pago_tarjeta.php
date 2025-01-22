<?php
    
    ini_set('display_errors','1');
    error_reporting(6143);	 
	 
	//$ManagerSuscripcionPremium = $this->getManager("ManagerSuscripcionPremium");
	$ManagerMetodoPago = $this->getManager("ManagerMetodoPago");
	
	$request = $this->request;
	//$request["idmedico"] = $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["medico"]["idmedico"];

    //$ManagerSuscripcionPremium->debug();
  	//$suscripcion = $ManagerSuscripcionPremium->getSuscripcionActiva($request["idmedico"]);

  	//$request["idsuscripcion"] = $suscripcion["idsuscripcion_premium"];
  	$request["cuotas"] = CANTIDAD_MESES_SUSCRIPCION;
  	$request["monto"] = MONTO_CUOTA;
  	$request["email"] =  $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["user"]["email"];
  	//$request["email"] = "test_user_78249207@testuser.com";//usuario testing

  	/*echo "<pre>";
  	print_r ($_SESSION[URL_ROOT][CONTROLLER]['logged_account']["user"]["email"]);
  	echo "</pre>";*/

  	//$enlace = $ManagerMetodoPago->getEnlacePagoRecurrenteMP($request);
  	//$this->assign("enlace", $enlace);
    
    if(!empty($request["idsuscripcion"])){
        $request["email"] =  $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["user"]["email"];
        $checkoutSessionId = $ManagerMetodoPago->createSubscriptionPaymentStripe($request);
    }
    
    $this->assign("checkout_session_id", $checkoutSessionId);
    $this->assign("p_key", STRIPE_APIKEY_PUBLIC);