<?php
 /**
  * Cron que genera los turnos para el próximo mes en base a la configuración de la agenda actual
  */
       
$ManagerTurno=$this->getManager("ManagerTurno");

$ManagerTurno->generate_cron();
