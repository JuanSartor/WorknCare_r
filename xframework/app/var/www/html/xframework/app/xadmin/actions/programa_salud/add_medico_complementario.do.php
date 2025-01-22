<?php

$this->start();
$manager = $this->getManager("ManagerProgramaSaludMedicoComplementario");
// $manager->debug();
$result = $manager->insert($this->request);
$this->finish($manager->getMsg());
