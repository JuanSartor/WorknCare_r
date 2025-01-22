<?php

/**
 *  Vacuna Edad >> FORm
 *  
 * */
 
if (isset($this->request["id"]) && $this->request["id"] > 0) {
    $manager = $this->getManager("ManagerVacunaEdad");
    $record = $manager->get($this->request["id"]);
    
    if($record){
        $ManagerVacuna = $this->getManager("ManagerVacuna");
        $this->assign("combo_vacunas", $ManagerVacuna->getCombo());
    }

    $this->assign("record", $record);
}

$ManagerUnidadTemporal = $this->getManager("ManagerUnidadTemporal");
$this->assign("combo_unidad_temporal", $ManagerUnidadTemporal->getCombo());