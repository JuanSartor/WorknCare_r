<?php

  
  
  
  $managerPacienteGrupoFamiliar = $this->getManager("ManagerPacienteGrupoFamiliar");
  
  $managerPaciente = $this->getManager("ManagerPaciente");
  
  
  //Fuerzo el cambio de miembro
  $managerPaciente->change_member_session(["requerimiento" => "all"]);

  $all_members = $managerPacienteGrupoFamiliar->getAllPacientesFamiliares($this->request);


  $paciente = $managerPaciente->get($_SESSION[URL_ROOT]["paciente_p"]['logged_account']["paciente"]["idpaciente"]);


  
  $this->assign("paciente_titular", $paciente);

  if (count($all_members) > 0) {
      //Listado de todos los miembros de un grupo...
      $this->assign("all_members", $all_members);
//print_r($all_members);
      
      
      
  }


  $this->assign("filter_selected", "all");
  $this->assign("filter", "all");


  $this->assign("actual_submodule", $this->request["submodulo"]);
  