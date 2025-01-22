<?php

/** 	
 * 	Accion: Listado de reembolsos
 * 	
 */
$manager = $this->getManager("ManagerReembolso");

$records = $manager->getListadoReembolsosJSON($this->request, $manager->getDefaultPaginate());
echo $records;
