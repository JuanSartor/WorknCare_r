<?php

$managaPa = $this->getManager("ManagerPagoRecompensaEncuesta");
$cuestionario_listo = $managaPa->getCuestionListoEmpresa();
$this->assign("cuestionario_listo", $cuestionario_listo);

$this->assign("fecha_cuestionario", fechaToString($cuestionario_listo["fecha_fin"]));

$pago = $managaPa->getByField("cuestionario_idcuestionario", $cuestionario_listo["idcuestionario"]);
$this->assign("pago", $pago);
