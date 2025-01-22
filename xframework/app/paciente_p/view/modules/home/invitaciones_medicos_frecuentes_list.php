<?php

$ManagerPacienteMedicoInvitacion=$this->getManager("ManagerPacienteMedicoInvitacion");
$solo_pendientes=true;
$listado_invitaciones=$ManagerPacienteMedicoInvitacion->getListadoInvitaciones($solo_pendientes);

$this->assign("listado_invitaciones",$listado_invitaciones);