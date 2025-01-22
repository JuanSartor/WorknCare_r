<?php

$this->start();

$manager = $this->getManager("ManagerEmpresa");
$manager->actualizar_suscripcion($this->request);
$this->finish($manager->getMsg());
