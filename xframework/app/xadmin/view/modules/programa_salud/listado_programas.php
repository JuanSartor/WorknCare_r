<?php

/**
 *  modulo para obtener todos los programas y/o los programas asociados a un grupo
 */

$ManagerProgramaSaludGrupoAsociacion = $this->getManager("ManagerProgramaSaludGrupoAsociacion");

$listado_programas = $ManagerProgramaSaludGrupoAsociacion->getListadoProgramas(["idprograma_salud_grupo" => $this->request["idprograma_salud_grupo"]]);
$this->assign("listado_programas", $listado_programas);
$combo_programas = $ManagerProgramaSaludGrupoAsociacion->getComboProgramas(["idprograma_salud_grupo" => $this->request["idprograma_salud_grupo"]]);
$this->assign("combo_programas", $combo_programas);

