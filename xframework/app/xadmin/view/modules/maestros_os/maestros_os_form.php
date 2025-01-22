<?php

/**
 *  Obras Sociales / Prepaga >>  Alta 
 *  
 * */
 
if (isset($this->request["id"]) && $this->request["id"] > 0) {
    $manager = $this->getManager("ManagerObrasSociales");
    $record = $manager->get($this->request["id"]);

    $this->assign("record", $record);
}
?>