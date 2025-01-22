<?php


$this->start();
$manager = $this->getManager("ManagerMotivoConsultaExpressProgramaCategoria");
// $manager->debug();
$result = $manager->insert($this->request);
$this->finish($manager->getMsg());
