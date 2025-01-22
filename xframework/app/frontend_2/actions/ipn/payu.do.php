<?php

    $myFile = path_files("ipn_log_payu.txt");

    $fh = fopen($myFile, 'a');
    fwrite($fh, "-------");
    fwrite($fh, date("Y-m-d H:i:s"));
    fwrite($fh, print_r($this->request, true));
    fclose($fh);
  
    //proceso el pago
    $ManagerMetodoPago = $this->getManager("ManagerMetodoPago");
    $ManagerMetodoPago->debug();
    
    $resultadoProceso = $ManagerMetodoPago->processNotificationPayU($this->request);
    header("HTTP/1.1 200 OK");
