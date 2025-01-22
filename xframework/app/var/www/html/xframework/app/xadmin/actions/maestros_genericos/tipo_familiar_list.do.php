<?php

/** 	
 * 	Accion: Grilla del Listado de  Tipo de Familiar
 * 	
 */
$manager = $this->getManager("ManagerTipoFamiliar");
//$manager->debug();
$records = $manager->getListadoJSON($this->request,$manager->getDefaultPaginate());

echo $records;
