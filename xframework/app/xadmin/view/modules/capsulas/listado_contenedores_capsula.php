<?php

/**
 *  modulo para obtener todos los cuestionario de la familia
 */
$ManagerCuestionario = $this->getManager("ManagerContenedorCapsula");
$listado_contenedores = $ManagerCuestionario->getListadoContenedores(["id_familia_capsula" => $this->request["id_familia_capsula"]]);

$this->assign("listado_contenedores", $listado_contenedores);


