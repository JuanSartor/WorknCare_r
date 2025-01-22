<?php

/**
 * Cron utilizado para verificar y cancelar las suscripciones al Pass bien-être
 */
$ManagerProgramaSaludSuscripcion = $this->getManager("ManagerProgramaSaludSuscripcion");
//$ManagerProgramaSaludSuscripcion->debug();

$ersultado = $ManagerProgramaSaludSuscripcion->cron_actualizar_suscripcion();
//$this->finish($ManagerProgramaSaludSuscripcion->getMsg());
