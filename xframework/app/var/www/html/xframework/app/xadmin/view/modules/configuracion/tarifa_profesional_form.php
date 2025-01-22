<?php
$file = @fopen(path_config("init.config.php"), "r");

if ($file) {
    while (($buffer = fgets($file)) !== false) {

        if(strpos($buffer,"MONTO_CUOTA")>-1){
          
             $monto = preg_replace("/[^\d]+/i", "", $buffer);
           
             $this->assign("valor",$monto) ;
        }
    }
    if (!feof($file)) {
          $this->assign("valor","Error: fallo inesperado") ;
       
    }
    fclose($file);
}