<?php

/**
 *  Tipo Cobertura
 *  
 * */
 
if (isset($this->request["id"]) && $this->request["id"] > 0) {
    $manager = $this->getManager("ManagerTipoFamiliar");
    $record = $manager->get($this->request["id"]);

    $this->assign("record", $record);
}