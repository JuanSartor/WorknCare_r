<?php

/**
 *  Grillas >>  Alta / Modificación
 *  
 * */
if (isset($this->request["id"]) && $this->request["id"] > 0) {
    $manager = $this->getManager("ManagerGrilla");
    $record = $manager->get($this->request["id"]);

    $this->assign("record", $record);

}
