<?php
    //$ManagerCompraCredito = $this->getManager("ManagerCompraCredito");
    //$ManagerMetodoPago = $this->getManager("ManagerMetodoPago");
    
    $compra = $ManagerCompraCredito->compra_credito($this->request["monto_compra"],$this->request["codigo"]);
    
    if($compra){
        $result = $ManagerCompraCredito->getMsg();
        $request = $this->request;
        $request["idcompra_credito"] = (int)$result["id"];
        $request["monto"] = (float)$result["monto_compra"];
       
        //$request["email"] =  $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["user"]["email"];
        //$request["email"] = "test_user_24182223@testuser.com";//usuario testing

        $enlace = $ManagerMetodoPago->getEnlaceMP($request);
    }
    
    $this->assign("enlace", $enlace);