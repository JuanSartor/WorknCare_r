<?php
  // Debo instanciar el paciente
  $ManagerPaciente = $this->getManager("ManagerPaciente");

  //Paciente que se encuentra en el array de SESSION de header paciente
  $paciente = $ManagerPaciente->getPacienteXHeader();
  
  $this->assign("paciente", $paciente);
 
  $ManagerEnfermedad = $this->getManager("ManagerEnfermedad");
  $this->assign("combo_enfermedad", $ManagerEnfermedad->getCombo());
  
    //Patologías actuales
  $ManagerPatologiasActuales = $this->getManager("ManagerPatologiasActuales");
  $this->assign("patologias_actuales", $ManagerPatologiasActuales->getByField("paciente_idpaciente", $paciente["idpaciente"]));
//actualizo el siguien step que se va a cargar

$this->getManager("ManagerPerfilSaludStatus")->update_wizard_step(6, $paciente["idpaciente"]);

