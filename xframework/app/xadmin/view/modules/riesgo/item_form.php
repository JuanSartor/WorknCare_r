<?php

/**
 *  cuestionarios
 *  
 * */
if (isset($this->request["id"]) && $this->request["id"] > 0) {
    $manager = $this->getManager("ManagerItemRiesgo");
    $record = $manager->get($this->request["id"]);

    $this->assign("record", $record);
}
$ManagerFamCuest = $this->getManager("ManagerFamiliaRiesgo");
$this->assign("familias", $ManagerFamCuest->getCombo());
