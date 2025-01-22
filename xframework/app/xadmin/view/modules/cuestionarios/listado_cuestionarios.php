<?php

/**
 *  modulo para obtener todos los cuestionario de la familia
 */
$ManagerCuestionario = $this->getManager("ManagerCuestionario");
$listado_cuestionarios = $ManagerCuestionario->getListadoCuestionarios(["id_familia_cuestionarios" => $this->request["id_familia_cuestionarios"]]);

$this->assign("listado_cuestionarios", $listado_cuestionarios);


