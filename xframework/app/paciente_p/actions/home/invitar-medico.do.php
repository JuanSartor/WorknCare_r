<?php

$ManagerPacienteMedicoInvitacion=$this->getManager("ManagerPacienteMedicoInvitacion");
$ManagerPacienteMedicoInvitacion->invitar_medico($this->request);
$this->finish($ManagerPacienteMedicoInvitacion->getMsg());
