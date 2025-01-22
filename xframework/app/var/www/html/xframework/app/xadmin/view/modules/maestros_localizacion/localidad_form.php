<?php

/** 	
 * 	Modulo PHP: Formulario de creacion/edicion de localidades
 *
 * 	@author UTN
 * 	@version 1.0
 * 	@package app\view\modules\maestros_localizacion
 *
 */
$manager = $this->getManager("ManagerLocalidad");

if (isset($this->request["id"]) && $this->request["id"] > 0) {

    $record = $manager->get($this->request["id"]);
    $this->assign("record", $record);
}
$pais = $this->getManager("ManagerPais")->get($this->request["pais_idpais"]);
$this->assign("pais", $pais);
?>