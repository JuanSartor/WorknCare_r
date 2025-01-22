<?php

$this->start();

$manager = $this->getManager("ManagerProgramaSaludSuscripcion");
$manager->cancelar_compra_suscripcion_pack($this->request);
$this->finish($manager->getMsg());
