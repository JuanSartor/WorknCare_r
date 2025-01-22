<?php

/**
 *  Títulos Profesionales >>  Alta 
 *  
 * */
 
if (isset($this->request["id"]) && $this->request["id"] > 0) {
    $manager = $this->getManager("ManagerTituloProfesional");
    $record = $manager->get($this->request["id"]);

    $this->assign("record", $record);
}