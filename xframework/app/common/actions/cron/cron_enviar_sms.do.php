<?php
 /**
  * Cron que recorre la tabla de log sms y envia cada uno que este pendiente, luego actualiza su estado
  */
       
$ManagerLogSms=$this->getManager("ManagerLogSMS");
$ManagerLogSms->debug();
$ManagerLogSms->enviarSMSBuffer();
