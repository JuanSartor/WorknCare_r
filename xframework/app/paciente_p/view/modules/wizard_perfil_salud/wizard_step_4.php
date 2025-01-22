<?php

  //Paciente que se encuentra en el array de SESSION de header paciente
  $ManagerPaciente = $this->getManager("ManagerPaciente");
  $paciente = $ManagerPaciente->getPacienteXHeader();
  $this->assign("paciente", $paciente);

  
  
   //Antecedentes personales
  $ManagerAntecedentesPersonales = $this->getManager("ManagerAntecedentesPersonales");
  $antecedente=$ManagerAntecedentesPersonales->getByField("paciente_idpaciente", $paciente["idpaciente"]);

  $this->assign("antecedente", $antecedente);

//actualizo el siguien step que se va a cargar

$this->getManager("ManagerPerfilSaludStatus")->update_wizard_step(4, $paciente["idpaciente"]);

