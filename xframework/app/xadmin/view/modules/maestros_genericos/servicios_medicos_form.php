<?php

/**
 *  Servicios Médicos >>  Alta 
 *  
 * */
 
if (isset($this->request["id"]) && $this->request["id"] > 0) {
    $manager = $this->getManager("ManagerServiciosMedicos");
    $record = $manager->get($this->request["id"]);

    $this->assign("record", $record);
}
?>