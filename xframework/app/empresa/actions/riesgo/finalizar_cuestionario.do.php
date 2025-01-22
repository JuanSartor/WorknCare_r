<?php

/**
 * actualizo el estado del cuestionario a finalizado
 */
$managerCues = $this->getManager("ManagerCuestionario");
// creo una copia asi aparece en mis modelos
$cuest = $managerCues->get($this->request["idcuestionario"]);
$cuest["band"]=1;
$managerCues->crearCuestionarioEmpresa($cuest);

$datActual = date('Y-m-d');
$managerCues->update(["estado" => '2', "fecha_finalizacion" => $datActual], $this->request["idcuestionario"]);
$this->finish($managerCues->getMsg());

