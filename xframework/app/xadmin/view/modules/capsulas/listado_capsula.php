<?php

/**
 *  modulo para obtener todos los cuestionario de la familia
 */
$ManagerCuestionario = $this->getManager("ManagerCapsula");
$listado_cuestionarios = $ManagerCuestionario->getListadoCapsulasFormContenedor(["contenedorcapsula_idcontenedorcapsula" => $this->request["contenedorcapsula_idcontenedorcapsula"]]);

$this->assign("listado_capsulas", $listado_cuestionarios);
