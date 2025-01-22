<?php

/**
 *  Familia de cuestionarios
 *  
 * */
if (isset($this->request["id"]) && $this->request["id"] > 0) {
    $manager = $this->getManager("ManagerFamiliaCapsula");
    $record = $manager->get($this->request["id"]);

    $this->assign("record", $record);
}
