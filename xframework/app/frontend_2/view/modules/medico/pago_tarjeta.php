<?php

       


	$ManagerSuscripcionPremium = $this->getManager("ManagerSuscripcionPremium");
	$ManagerMetodoPago = $this->getManager("ManagerMetodoPago");
	$ManagerMedico = $this->getManager("ManagerMedico"); // Agregado por seba 03/03/2017
	
	$request = $this->request;
        
	// Agregado por seba 03/03/2017
	//print_r($_SESSION[URL_ROOT][CONTROLLER]['logged_account']["medico"]);
	
    if($request["idmedico"]!=""){
	
		$medico = $ManagerMedico->get($request["idmedico"]);
            
    // Agregado por seba 03/03/2017    
	/*	Quito esto porque según vi en el log está enviando idmedico por request
https://www.doctorplus.eu/profesional/frontend_2.php?&modulo=medico&submodulo=pago_tarjeta&idmedico=6&fromajax=1&

	$request["idmedico"] = $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["medico"]["idmedico"]; 
	*/

  	$suscripcion = $ManagerSuscripcionPremium->getSuscripcionActiva($request["idmedico"]);

  	$request["idsuscripcion"] = $suscripcion["idsuscripcion_premium"];
  	$request["cuotas"] = CANTIDAD_MESES_SUSCRIPCION;
  	$request["monto"] = MONTO_CUOTA;
	
	// Agregado por seba 03/03/2017
  	$request["email"] =  $medico["email"];
	// $request["email"] =  $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["user"]["email"];
  	//$request["email"] = "test_user_78249207@testuser.com";//usuario testing


  	$enlace = $ManagerMetodoPago->getEnlacePagoRecurrenteMP($request);

  	$this->assign("enlace", $enlace);
        }