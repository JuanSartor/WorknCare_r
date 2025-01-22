<?php

/** 	
 * 	Accion: Grilla del Listado de Motivos de Consulta Express
 * 	
 */
$manager = $this->getManager("ManagerMotivoConsultaExpress");
//$manager->debug();
$records = $manager->getListadoJSON($this->request,$manager->getDefaultPaginate());

echo $records;
