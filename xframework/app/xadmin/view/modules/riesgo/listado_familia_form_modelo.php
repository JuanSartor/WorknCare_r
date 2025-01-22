<?php

/**
 *  modulo para obtener todos los cuestionario de la familia
 */
$ManagerCuestionario = $this->getManager("ManagerFamiliaRiesgo");
$listado_cuestionarios = $ManagerCuestionario->getListadoFamilias(["idmodelos_riesgos" => $this->request["idmodelos_riesgos"]]);

$this->assign("listado_cuestionarios", $listado_cuestionarios);

$this->assign("idmodelos_riesgos", $this->request["idmodelos_riesgos"]);
