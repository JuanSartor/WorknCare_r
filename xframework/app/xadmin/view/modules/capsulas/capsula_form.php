<?php

/**
 *  cuestionarios
 *  
 * */
if (isset($this->request["id"]) && $this->request["id"] > 0) {
    $manager = $this->getManager("ManagerCapsula");
    $record = $manager->get($this->request["id"]);

    $this->assign("record", $record);
}


$ManagerFamCuest = $this->getManager("ManagerContenedorCapsula");
$this->assign("familias", $ManagerFamCuest->getCombo());
