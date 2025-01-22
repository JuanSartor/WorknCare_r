<?php

//accion para  agregar vacaciones del medico
$ManagerMedicoVacaciones=$this->getManager("ManagerMedicoVacaciones");
$ManagerMedicoVacaciones->agregar_vacaciones($this->request);
$this->finish($ManagerMedicoVacaciones->getMsg());