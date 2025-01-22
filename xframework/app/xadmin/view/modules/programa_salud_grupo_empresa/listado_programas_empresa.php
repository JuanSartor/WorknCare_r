<?php

/**
 *  modulo para obtener todos los programas y/o los programas asociados a un grupo
 */
$ManagerProgramaSaludGrupoAsociacion = $this->getManager("ManagerProgramaSaludGrupoEmpresaAsociacion");
$listado_programas = $ManagerProgramaSaludGrupoAsociacion->getListadoProgramas(["idprograma_salud_grupo_empresa" => $this->request["idprograma_salud_grupo_empresa"]]);

$this->assign("listado_programas", $listado_programas);
$combo_programas = $ManagerProgramaSaludGrupoAsociacion->getComboProgramas(["idprograma_salud_grupo_empresa" => $this->request["idprograma_salud_grupo_empresa"]]);
$this->assign("combo_programas", $combo_programas);

