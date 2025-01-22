<?php

$ManagerMedicoPacienteInvitacion=$this->getManager("ManagerMedicoPacienteInvitacion");

$listado_invitaciones=$ManagerMedicoPacienteInvitacion->getListadoPacientesInviacionPendiente();

$this->assign("listado_invitaciones",$listado_invitaciones);