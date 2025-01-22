<?php
 /**
  * Cron que recorre la tabla de mail y envia cada uno que este pendiente, luego actualiza su estado
  */
       
$ManagerMail=$this->getManager("ManagerMail");
//$ManagerMail->debug();
$ManagerMail->enviarMailsBuffer();
