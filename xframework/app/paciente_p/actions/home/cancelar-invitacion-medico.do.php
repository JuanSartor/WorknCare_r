<?php

$ManagerPacienteMedicoInvitacion=$this->getManager("ManagerPacienteMedicoInvitacion");
$ManagerPacienteMedicoInvitacion->delete($this->request["id"],true);
$this->finish($ManagerPacienteMedicoInvitacion->getMsg());
