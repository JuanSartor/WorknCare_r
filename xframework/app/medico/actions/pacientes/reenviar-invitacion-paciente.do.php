<?php

$ManagerMedicoPacienteInvitacion=$this->getManager("ManagerMedicoPacienteInvitacion");
$ManagerMedicoPacienteInvitacion->reenviar_invitacion_paciente($this->request);
$this->finish($ManagerMedicoPacienteInvitacion->getMsg());
