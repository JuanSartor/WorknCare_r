<?php

  $myFile = path_files("ipn_log_mp.txt");

  $fh = fopen($myFile, 'a');
  fwrite($fh, "-------");
  fwrite($fh, date("Y-m-d H:i:s"));
  fwrite($fh, print_r($this->request, true));
  fwrite($fh, $this->request["Notificacion"] . "\n");
  fclose($fh);

  
  
//proceso el pago
  $topic = isset($this->request["topic"])? $this->request["topic"] : "" ;
      

      $ManagerMetodoPago = $this->getManager("ManagerMetodoPago");
    
    $ManagerMetodoPago->debug();
    $resultadoProceso = $ManagerMetodoPago->processNotificationMP($this->request["id"]);

   

  if($topic == "preapproval"){
    header("HTTP/1.1 200 OK");
  }else{
 

    if ($resultadoProceso) {
        //aviso al servidor de mercadopago que me llego el ipn
        header("HTTP/1.1 200 OK");
    }else{
        header("HTTP/1.1 200 OK");
    }
  }


  