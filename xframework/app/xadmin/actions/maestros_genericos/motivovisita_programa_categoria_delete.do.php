<?php


$this->start();

$manager = $this->getManager("ManagerMotivoVisitaProgramaCategoria");
 //$manager->debug();
$result = $manager->delete($this->request["id"]);
$this->finish($manager->getMsg());
