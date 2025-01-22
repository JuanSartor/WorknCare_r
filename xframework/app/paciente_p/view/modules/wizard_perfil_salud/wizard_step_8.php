<?php

// Debo instanciar el paciente
$ManagerPaciente = $this->getManager("ManagerPaciente");

//Paciente que se encuentra en el array de SESSION de header paciente
$paciente = $ManagerPaciente->getPacienteXHeader();

$this->assign("paciente", $paciente);

$ManagerPerfilSaludAlergia = $this->getManager("ManagerPerfilSaludAlergia");
$perfil_salud_alergia = $ManagerPerfilSaludAlergia->getByField("paciente_idpaciente", $paciente["idpaciente"]);
$this->assign("record", $perfil_salud_alergia);

$ManagerSubTipoAlergia = $this->getManager("ManagerSubTipoAlergia");
$listado = $ManagerSubTipoAlergia->getArrayAlergiasPaciente($paciente["idpaciente"]);
//$ManagerSubTipoAlergia->print_r($listado);

$this->assign("listado_alergias", $listado);
//actualizo el siguien step que se va a cargar

$this->getManager("ManagerPerfilSaludStatus")->update_wizard_step(8, $paciente["idpaciente"]);
