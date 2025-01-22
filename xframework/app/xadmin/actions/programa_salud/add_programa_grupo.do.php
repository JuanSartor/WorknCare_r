<?php

$this->start();
$manager = $this->getManager("ManagerProgramaSaludGrupoAsociacion");
// $manager->debug();
$result = $manager->insert($this->request);
$this->finish($manager->getMsg());
