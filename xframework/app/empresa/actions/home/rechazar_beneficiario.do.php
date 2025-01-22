<?php

$this->start();
$this->request["estado"] = 0;
$manager = $this->getManager("ManagerPacienteEmpresa");
$manager->cambiar_estado($this->request);
$this->finish($manager->getMsg());
