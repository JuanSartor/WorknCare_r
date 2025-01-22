<?php
 /**
  * Cron que corre todos los 1 de cada mes para la generación de los períodos de pago, 
  * además se cierran los períodos actuales
  */
       
$ManagerPeriodoPago=$this->getManager("ManagerPeriodoPago");
$ManagerPeriodoPago->debug();
$ManagerPeriodoPago->cronCreacionPeriodoPago();
