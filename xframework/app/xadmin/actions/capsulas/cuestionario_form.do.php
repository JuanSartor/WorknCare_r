<?php

/** 	
 * 	Accion: gestion de Cuestionarios
 * 	
 */
$this->start();
$ManagerPago = $this->getManager("ManagerPagoRecompensaEncuesta");
$hoy = date("Y-m-d");
$pago = $ManagerPago->update(["pago_pendiente" => $this->request["pago_pendiente"], "fecha_pago_factura" => $hoy], $this->request["idpago"]);

$manager = $this->getManager("ManagerCuestionario");
// $manager->debug();
$result = $manager->process($this->request);
$this->finish($manager->getMsg());
