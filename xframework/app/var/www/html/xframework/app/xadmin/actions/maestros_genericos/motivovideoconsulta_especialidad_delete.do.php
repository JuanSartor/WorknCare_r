<?php


$this->start();
$manager = $this->getManager("ManagerMotivoVideoConsultaEspecialidad");
// $manager->debug();
$result = $manager->delete($this->request["id"]);
$this->finish($manager->getMsg());
