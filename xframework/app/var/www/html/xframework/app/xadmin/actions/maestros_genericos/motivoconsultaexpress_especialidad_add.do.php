<?php


$this->start();
$manager = $this->getManager("ManagerMotivoConsultaExpressEspecialidad");
// $manager->debug();
$result = $manager->insert($this->request);
$this->finish($manager->getMsg());
