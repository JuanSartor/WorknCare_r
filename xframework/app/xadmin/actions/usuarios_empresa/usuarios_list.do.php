<?php

/**
 * 	
 *  Puestos
 *
 * 	@author Emanuel del Barco
 *
 */
$manager = $this->getManager("ManagerEmpresa");

$idpaginate = "listado_empresa";

$records = $manager->getEmpresasJSON( $this->request,$idpaginate);

echo $records;
?>
