<?php

$this->start();
$manager = $this->getManager("ManagerPacienteEmpresa");
$manager->eliminar_beneficiario($this->request);
$this->finish($manager->getMsg());
