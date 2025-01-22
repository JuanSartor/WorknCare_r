<?php


$this->start();
$manager = $this->getManager("ManagerUsuarioAcceso");
// $manager->debug();
$result = $manager->insert($this->request);
$this->finish($manager->getMsg());
