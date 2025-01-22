<?php

/** 	
 * 	Modulo PHP: Listado de localidades
 *
 * 	@author UTN
 * 	@version 1.0
 * 	@package app\view\modules\maestros_localizacion
 *
 */
$manager = $this->getManager("ManagerLocalidad");


$paginate = SmartyPaginate::getPaginate($manager->getDefaultPaginate());


$pais = $this->getManager("ManagerPais")->get($this->request["pais_idpais"]);
$this->assign("pais", $pais);

$this->assign("paginate", $paginate);
?>
