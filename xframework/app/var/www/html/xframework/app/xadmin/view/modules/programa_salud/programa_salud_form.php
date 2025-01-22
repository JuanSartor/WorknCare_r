<?php

/**
 *  programas de salud
 *  
 * */
 
if (isset($this->request["id"]) && $this->request["id"] > 0) {
    $manager = $this->getManager("ManagerProgramaSalud");
    $record = $manager->get($this->request["id"]);

    $this->assign("record", $record);
}
