<?php

$ManagerMedicoPacienteInvitacion=$this->getManager("ManagerMedicoPacienteInvitacion");
$ManagerMedicoPacienteInvitacion->delete($this->request["id"],true);
$this->finish($ManagerMedicoPacienteInvitacion->getMsg());
