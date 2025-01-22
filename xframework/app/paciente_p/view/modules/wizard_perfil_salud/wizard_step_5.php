<?php
  // Debo instanciar el paciente
  $ManagerPaciente = $this->getManager("ManagerPaciente");

  //Paciente que se encuentra en el array de SESSION de header paciente
  $paciente = $ManagerPaciente->getPacienteXHeader();
  
  $this->assign("paciente", $paciente);
 
  $ManagerEnfermedad = $this->getManager("ManagerEnfermedad");
  $this->assign("combo_enfermedad", $ManagerEnfermedad->getCombo());
  
   //Tags Inputs
  $ManagerEnfermedadesActuales = $this->getManager("ManagerEnfermedadesActuales");
  $tags = $ManagerEnfermedadesActuales->getTagsInputs($paciente["idpaciente"]);
  
  $this->assign("perfiles_patologias", $tags);
  
    //Enfermedades actuales y tipos de enfermedad
  $this->assign("enfermedad_actual", $ManagerEnfermedadesActuales->getByField("paciente_idpaciente", $paciente["idpaciente"]));
//actualizo el siguien step que se va a cargar

$this->getManager("ManagerPerfilSaludStatus")->update_wizard_step(5, $paciente["idpaciente"]);

