<?php

/**
 *  Pack SMS Médico >>  Alta - Modificación
 *  
 * */
 
if (isset($this->request["id"]) && $this->request["id"] > 0) {
    $manager = $this->getManager("ManagerPinesPaciente");
    $record = $manager->get($this->request["id"]);

    $this->assign("record", $record);
}
?>