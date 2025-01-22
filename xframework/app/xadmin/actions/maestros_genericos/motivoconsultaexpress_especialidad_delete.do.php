<?php


$this->start();
$manager = $this->getManager("ManagerMotivoConsultaExpressEspecialidad");
// $manager->debug();
$result = $manager->delete($this->request["id"]);
$this->finish($manager->getMsg());
