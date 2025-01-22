<?php


$this->start();
$manager = $this->getManager("ManagerUsuarioAcceso");
// $manager->debug();
$result = $manager->delete($this->request["id"]);
$this->finish($manager->getMsg());
