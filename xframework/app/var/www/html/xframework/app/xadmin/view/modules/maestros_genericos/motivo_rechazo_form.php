<?php

/**
 *  Motivos de Consulta Express
 *  
 * */
 
if (isset($this->request["id"]) && $this->request["id"] > 0) {
    $manager = $this->getManager("ManagerMotivoRechazo");
    $record = $manager->get($this->request["id"]);

    $this->assign("record", $record);
}