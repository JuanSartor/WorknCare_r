<?php

/**
 * action que activa el pago del cuestionario por factura
 */
$pago = $this->getManager("ManagerPagoRecompensaEncuesta")->get($this->request["idpago_recompensa_encuesta"]);
$managerCues = $this->getManager("ManagerCuestionario");
$managerCues->update(["estado" => '1'], $pago["cuestionario_idcuestionario"]);

$managerEmpresa = $this->getManager("ManagerEmpresa");
$requestEmpresa["pais"] = $this->request["pais"];
$requestEmpresa["direccion"] = $this->request["direccion"];
$requestEmpresa["ciudad"] = $this->request["ciudad"];
$requestEmpresa["siret"] = $this->request["siret"];
$requestEmpresa["codigo_postal"] = $this->request["codigo_postal"];
$managerEmpresa->crear_pago_factura_pago_cuestionario_por_factura($pago);
$managerEmpresa->basic_update($requestEmpresa, $this->request["idempresa"]);

$managerPago = $this->getManager("ManagerPagoRecompensaEncuesta");
$requestPago["pago_pendiente"] = $this->request["pago_pendiente"];
$managerPago->update($requestPago, $this->request["idpago_recompensa_encuesta"]);

$result = $managerEmpresa->generar_hash_invitacion_cuestionario($pago["cuestionario_idcuestionario"]);
$this->finish($managerEmpresa->getMsg());

