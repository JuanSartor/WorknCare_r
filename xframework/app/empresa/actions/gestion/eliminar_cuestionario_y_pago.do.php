<?php

/**
 * elimino el cuestionario y el pago de stripe si es con tarjeta,
 *  sino solo actualizo la eliminacion en la bd
 */
$manager = $this->getManager("ManagerPagoRecompensaEncuesta");
//$manager->debug();
$manager->eliminarCuestionarioYPago($this->request["idcuestionario"]);

$this->finish($manager->getMsg());


