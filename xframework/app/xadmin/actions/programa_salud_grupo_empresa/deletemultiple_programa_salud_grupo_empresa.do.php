<?php

/** 	
 * 	Accion: Eliminacion mutiple grupos
 *
 *
 */
$manager = $this->getManager("ManagerProgramaSaludGrupoEmpresa");
$managerA = $this->getManager("ManagerProgramaSaludGrupoEmpresaAsociacion");


$ids = explode(",", $this->request['ids']);
foreach ($ids as $id) {

    $managerA->deleteAsociacion($id);
}

$manager->deleteMultiple($this->request['ids'], true);
$this->finish($manager->getMsg());
