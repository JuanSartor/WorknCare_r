<?php
//Paciente que se encuentra en el array de SESSION de header paciente
  $ManagerPaciente = $this->getManager("ManagerPaciente");
  $paciente = $ManagerPaciente->getPacienteXHeader();
  $this->assign("paciente", $paciente);
  
  $idpaginate = "paginacion_medico";
  $this->assign("idpaginate", $idpaginate);

  if (is_array($_SESSION[URL_ROOT][CONTROLLER]["request_busqueda_medico"])) {
      unset($_SESSION[URL_ROOT][CONTROLLER]["request_busqueda_medico"]);
  }
 
  $_SESSION[URL_ROOT][CONTROLLER]["request_busqueda_medico"] = $this->request;
  $tags_inputs = $this->getManager("ManagerMedico")->getTagsInputBusquedaProfesional($this->request);

  $this->assign("tags_inputs", $tags_inputs);
  

  if ((int) $this->request["especialidad_ti"] > 0) {
      $this->assign("especialidad", $this->getManager("ManagerEspecialidades")->get($this->request["especialidad_ti"]));
  }