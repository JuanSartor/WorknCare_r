<?php

$this->start();
$manager = $this->getManager("ManagerProgramaSaludMedicoReferente");
// $manager->debug();
$result = $manager->insert($this->request);
$this->finish($manager->getMsg());
