<?php

$this->start();

$manager = $this->getManager("ManagerProgramaSaludExcepcion");
$manager->registrar_programa_excepcion($this->request);
$this->finish($manager->getMsg());