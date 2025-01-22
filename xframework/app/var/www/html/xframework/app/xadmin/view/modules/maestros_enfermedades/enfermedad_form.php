<?php

/**
 *  Obras Sociales / Prepaga >>  Alta 
 *  
 * */
 
if (isset($this->request["id"]) && (int)$this->request["id"] > 0) {
    $manager = $this->getManager("ManagerEnfermedad");
    $record = $manager->get($this->request["id"]);

    $this->assign("record", $record);
}
?>