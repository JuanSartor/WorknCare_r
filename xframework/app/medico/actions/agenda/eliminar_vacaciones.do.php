<?php


//accion para  eliminar vacaciones del medico
$ManagerMedicoVacaciones=$this->getManager("ManagerMedicoVacaciones");
$ManagerMedicoVacaciones->delete($this->request["id"],true);
$this->finish($ManagerMedicoVacaciones->getMsg());