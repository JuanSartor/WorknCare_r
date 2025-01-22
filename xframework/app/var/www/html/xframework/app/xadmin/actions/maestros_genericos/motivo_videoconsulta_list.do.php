<?php

/** 	
 * 	Accion: Grilla del Listado de Motivos de Video Consulta
 * 	
 */
$manager = $this->getManager("ManagerMotivoVideoConsulta");
//$manager->debug();
$records = $manager->getListadoJSON($this->request,$manager->getDefaultPaginate());

echo $records;
