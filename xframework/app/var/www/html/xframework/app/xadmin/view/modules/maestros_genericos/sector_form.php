<?php

/**
 *  Sector >> FORm
 *  
 * */
 
if (isset($this->request["id"]) && $this->request["id"] > 0) {
    $manager = $this->getManager("ManagerSector");
    $record = $manager->get($this->request["id"]);

    $this->assign("record", $record);
}