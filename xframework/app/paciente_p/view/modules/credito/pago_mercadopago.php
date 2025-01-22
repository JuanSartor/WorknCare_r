<?php

/*
    $ManagerCompraCredito = $this->getManager("ManagerCompraCredito");
    $ManagerMetodoPago = $this->getManager("ManagerMetodoPago");
    
    $compra = $ManagerCompraCredito->compra_credito($this->request["monto_compra"],$this->request["codigo"]);
    
    if($compra){
        $result = $ManagerCompraCredito->getMsg();
        $request = $this->request;
        $request["idcompra_credito"] = (int)$result["id"];
        $request["monto"] = (float)$result["monto_compra"];
        $request["email"] =  $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["user"]["email"];
                   
        $checkoutSessionId = $ManagerMetodoPago->createOneTimePaymentStripe($request);
    }
    
    $this->assign("checkout_session_id", $checkoutSessionId);
    $this->assign("p_key", STRIPE_APIKEY_PUBLIC);
     
     */