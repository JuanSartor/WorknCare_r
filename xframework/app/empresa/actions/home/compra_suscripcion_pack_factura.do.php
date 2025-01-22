<?php

$this->start();

$manager = $this->getManager("ManagerProgramaSaludSuscripcion");
$manager->activar_compra_suscripcion_pack_factura($this->request);
$this->finish($manager->getMsg());
