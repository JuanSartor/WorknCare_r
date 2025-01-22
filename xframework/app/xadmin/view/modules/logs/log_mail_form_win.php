<?php

$manager = $this->getManager("ManagerMail");

if (isset($this->request["id"]) && $this->request["id"] > 0) {

    $record = $manager->get($this->request["id"]);
    $this->assign("record",$record);
}
?>
