<?php

$managerCues = $this->getManager("ManagerCuestionario");
$managerCues->update(["estado" => '4'], $this->request["idcuestionario"]);
$this->finish($managerCues->getMsg());



