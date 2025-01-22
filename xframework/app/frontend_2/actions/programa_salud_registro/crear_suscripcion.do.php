<?php

$this->start();
$manager = $this->getManager("ManagerProgramaSaludSuscripcion");
$manager->crear_suscripcion($this->request);
$this->finish($manager->getMsg());
