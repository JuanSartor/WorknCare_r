<?php

/**
 * Medicamento >>  Alta 
 *  
 * */
 
if (isset($this->request["id"]) && $this->request["id"] > 0) {
    $manager = $this->getManager("ManagerMedicamento");
    $record = $manager->get($this->request["id"]);

    $this->assign("record", $record);
}

$this->assign("combo_laboratorio", $this->getManager("ManagerLaboratorio")->getCombo());