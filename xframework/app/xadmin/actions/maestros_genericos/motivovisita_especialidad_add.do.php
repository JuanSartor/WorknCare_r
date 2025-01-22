<?php


$this->start();
$manager = $this->getManager("ManagerMotivoVisitaEspecialidad");
// $manager->debug();
$result = $manager->insert($this->request);
$this->finish($manager->getMsg());
