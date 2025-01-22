<?php

//accion para  agregar web profesionales del medico
$ManagerMedicoWebProfesional=$this->getManager("ManagerMedicoWebProfesional");
$ManagerMedicoWebProfesional->agregar_web_profesional($this->request);
$this->finish($ManagerMedicoWebProfesional->getMsg());