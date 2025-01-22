<?php


$this->start();

$manager = $this->getManager("ManagerMotivoVideoConsultaProgramaCategoria");
 //$manager->debug();
$result = $manager->delete($this->request["id"]);
$this->finish($manager->getMsg());
