<?php

/**
 *  Plan - nuevo/editar
 *  
 * */
if (isset($this->request["id"]) && (int) $this->request["id"] > 0) {
    $manager = $this->getManager("ManagerProgramaSaludPlan");
    $record = $manager->get($this->request["id"]);

    $this->assign("record", $record);

}
?>