<?php

  $this->assign("item_menu", "patology");

  //Paciente que se encuentra en el array de SESSION de header paciente
  $ManagerPaciente = $this->getManager("ManagerPaciente");
  $paciente = $ManagerPaciente->getPacienteXSelectMedico();
  $this->assign("paciente", $paciente);

  //Obtengo el perfil de antecedentes
  $ManagerPerfilSaludAntecedentes = $this->getManager("ManagerPerfilSaludAntecedentes");
  $record = $ManagerPerfilSaludAntecedentes->getByField("paciente_idpaciente", $paciente["idpaciente"]);
  $this->assign("record", $record);


  //Antecedentes personales
  $ManagerAntecedentesPersonales = $this->getManager("ManagerAntecedentesPersonales");
  $this->assign("antecedente", $ManagerAntecedentesPersonales->getByField("paciente_idpaciente", $paciente["idpaciente"]));

  //Patologías actuales
  $ManagerPatologiasActuales = $this->getManager("ManagerPatologiasActuales");
  $this->assign("patologias_actuales", $ManagerPatologiasActuales->getByField("paciente_idpaciente", $paciente["idpaciente"]));

  //Enfermedades actuales y tipos de enfermedad
  $ManagerEnfermedadesActuales = $this->getManager("ManagerEnfermedadesActuales");
  $this->assign("enfermedad_actual", $ManagerEnfermedadesActuales->getByField("paciente_idpaciente", $paciente["idpaciente"]));

  //Tags Inputs
  $tags_enf_actuales = $ManagerEnfermedadesActuales->getTagsInputs($paciente["idpaciente"]);
//$ManagerEnfermedadesActuales->print_r($tags_enf_actuales);die();
  $this->assign("perfiles_patologias", $tags_enf_actuales);

  //Obtengo los tags INputs
  $ManagerPerfilSaludConsulta = $this->getManager("ManagerPerfilSaludConsulta");
  $tags = $ManagerPerfilSaludConsulta->getInfoTags($paciente["idpaciente"]);
  if ($tags) {
      $this->assign("tags", $tags);
  }

  $ManagerEnfermedad = $this->getManager("ManagerEnfermedad");
  $this->assign("combo_enfermedad", $ManagerEnfermedad->getCombo());


  $estadoTablero = $this->getManager("ManagerPerfilSaludStatus")->getStatusPerfilPaciente($paciente["idpaciente"]);
  $this->assign("estadoTablero", $estadoTablero);


 $info_menu = $ManagerPaciente->getInfoMenu($paciente["idpaciente"]);
                    $this->assign("info_menu_paciente", $info_menu);
