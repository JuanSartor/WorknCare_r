<?php

$this->start();
$manager = $this->getManager("ManagerEmpresa");
// $manager->debug();

$result = $manager->process($this->request);
$result2 = $manager->transformarPNGAJPG($this->request["idempresa"]);
$this->finish($manager->getMsg());
