<?php

/**
 *  Vacuna >> FORm
 *  
 * */
 
if (isset($this->request["id"]) && $this->request["id"] > 0) {
    $manager = $this->getManager("ManagerCirugiaOcular");
    $record = $manager->get($this->request["id"]);

    $this->assign("record", $record);
}