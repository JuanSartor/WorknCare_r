<?php


//accion para  eliminar webs profesionales del medico
$ManagerMedicoWebProfesional=$this->getManager("ManagerMedicoWebProfesional");
$ManagerMedicoWebProfesional->delete($this->request["id"],true);
$this->finish($ManagerMedicoWebProfesional->getMsg());