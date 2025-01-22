<?php


$this->start();
$manager = $this->getManager("ManagerMotivoVisitaProgramaCategoria");
// $manager->debug();
$result = $manager->insert($this->request);
$this->finish($manager->getMsg());
