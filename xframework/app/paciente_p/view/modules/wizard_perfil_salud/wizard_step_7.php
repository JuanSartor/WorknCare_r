<?php
  // Debo instanciar el paciente
  $ManagerPaciente = $this->getManager("ManagerPaciente");

  //Paciente que se encuentra en el array de SESSION de header paciente
  $paciente = $ManagerPaciente->getPacienteXHeader();
  
  $this->assign("paciente", $paciente);
 

  //Obtengo el perfil de antecedentes
  $ManagerPerfilSaludAntecedentes = $this->getManager("ManagerPerfilSaludAntecedentes");
  $record = $ManagerPerfilSaludAntecedentes->getByField("paciente_idpaciente", $paciente["idpaciente"]);
  $this->assign("record", $record);

  //Manager del tipo familiar
  $ManagerTipoFamiliar = $this->getManager("ManagerTipoFamiliar");
  $this->assign("list_tipo_familiar", $ManagerTipoFamiliar->getList());

  //Listado de los tipos de patologías
  $ManagerTipoPatologia = $this->getManager("ManagerTipoPatologia");
  $this->assign("list_tipo_patologia", $ManagerTipoPatologia->getList());
  
    //Obtención de los tags_inputs
  $ManagerAntecedentesPatologiaFamiliar = $this->getManager("ManagerAntecedentesPatologiaFamiliar");
  $tags_inputs = $ManagerAntecedentesPatologiaFamiliar->getTagsInputs($paciente["idpaciente"]);
  $this->assign("perfiles_antecedentes", $tags_inputs);
  
  //actualizo el siguien step que se va a cargar

$this->getManager("ManagerPerfilSaludStatus")->update_wizard_step(7, $paciente["idpaciente"]);
