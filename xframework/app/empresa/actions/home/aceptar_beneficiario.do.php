<?php

$this->start();
$this->request["estado"] = 1;
$manager = $this->getManager("ManagerPacienteEmpresa");
$manager->cambiar_estado($this->request);
$this->finish($manager->getMsg());
