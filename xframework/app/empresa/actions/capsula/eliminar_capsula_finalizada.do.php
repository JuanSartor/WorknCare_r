<?php

$managerCues = $this->getManager("ManagerCapsula");
$managerCues->update(["estado" => '4'], $this->request["idcapsula"]);
$this->finish($managerCues->getMsg());



