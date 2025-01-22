<?php

/** 	
 * 	Accion: Grilla del Listado de Categorias de Programas de salud
 * 	
 */
$manager = $this->getManager("ManagerProgramaSaludCategoria");
//$manager->debug();
$records = $manager->getListadoJSON($this->request,$manager->getDefaultPaginate()."_".$this->request["idprograma_salud"]);

echo $records;
