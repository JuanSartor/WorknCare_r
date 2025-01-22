<?php


$this->start();
$manager = $this->getManager("ManagerMotivoVideoConsultaProgramaCategoria");
// $manager->debug();
$result = $manager->insert($this->request);
$this->finish($manager->getMsg());
