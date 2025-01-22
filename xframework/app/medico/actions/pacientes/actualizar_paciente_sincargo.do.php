<?php
$this->start();
$ManagerMedicoMisPacientes=$this->getManager("ManagerMedicoMisPacientes");
$ManagerMedicoMisPacientes->actualizarPacienteSinCargo($this->request);
$this->finish($ManagerMedicoMisPacientes->getMsg());

