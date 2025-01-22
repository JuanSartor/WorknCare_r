<?php

/** 	
 * 	Accion: Grilla del Listado de Cuestionarios
 * 	
 */
$manager = $this->getManager("ManagerCuestionario");

if ($this->request["generico"] == '0') {
    $records1 = $manager->getListadoJSON($this->request, $manager->getDefaultPaginate());
    echo $records1;
} else {
    $records2 = $manager->getListadoJSONGenericos($this->request, $manager->getDefaultPaginate());
    echo $records2;
}


