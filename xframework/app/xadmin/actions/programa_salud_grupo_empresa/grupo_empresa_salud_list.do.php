<?php

/** 	
 * 	Accion: Grilla del Listado de Grupos de Programas de salud
 * 	
 */
$manager = $this->getManager("ManagerProgramaSaludGrupoEmpresa");
//$manager->debug();
$records = $manager->getListadoJSON($this->request, $manager->getDefaultPaginate());

echo $records;
