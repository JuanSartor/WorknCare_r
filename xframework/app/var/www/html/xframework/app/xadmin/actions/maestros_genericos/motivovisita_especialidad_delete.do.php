<?php


$this->start();
$manager = $this->getManager("ManagerMotivoVisitaEspecialidad");
// $manager->debug();
$result = $manager->delete($this->request["id"]);
$this->finish($manager->getMsg());
