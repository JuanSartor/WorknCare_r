<?php

$manager = $this->getManager("ManagerLogSMS");

if (isset($this->request["id"]) && $this->request["id"] > 0) {

    $record = $manager->getDetalle($this->request["id"]);
    $this->assign("record",$record);
}
?>
