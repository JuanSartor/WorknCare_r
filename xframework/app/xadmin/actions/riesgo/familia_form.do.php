<?php

/** 	
 * 	Accion: gestion de Cuestionarios
 * 	
 */
$this->start();

$manager = $this->getManager("ManagerFamiliaRiesgo");
// $manager->debug();

$cad = '';
foreach ($this->request as $elemento) {

    if (strpos($elemento, 'chkk') !== false) {
        $porciones = explode("-", $elemento);
        $cad = $porciones[1] . "," . $cad;
    }
}

$this->request["modelos_riesgo_idmodelos_riesgo"] = substr($cad, 0, -1);

$result = $manager->process($this->request);
$this->finish($manager->getMsg());
