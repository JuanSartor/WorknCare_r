<?php

$this->start();
$manager = $this->getManager("ManagerEmpresa");
$manager->registrar_cantidad_empleados($this->request);
$this->finish($manager->getMsg());
