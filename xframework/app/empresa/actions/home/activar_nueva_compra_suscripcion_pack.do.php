<?php

$this->start();

$manager = $this->getManager("ManagerProgramaSaludSuscripcion");
$manager->activar_nueva_compra_suscripcion_pack($this->request);
$this->finish($manager->getMsg());
