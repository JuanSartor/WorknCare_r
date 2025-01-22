<?php

$ManagerPacienteMedicoInvitacion=$this->getManager("ManagerPacienteMedicoInvitacion");
$ManagerPacienteMedicoInvitacion->reenviar_invitacion_medico($this->request);
$this->finish($ManagerPacienteMedicoInvitacion->getMsg());
