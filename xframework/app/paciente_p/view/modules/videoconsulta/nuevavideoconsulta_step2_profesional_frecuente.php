<?php


  //Paciente que se encuentra en el array de SESSION de header paciente
  $ManagerPaciente = $this->getManager("ManagerPaciente");
  $paciente = $ManagerPaciente->getPacienteXHeader();
  $this->assign("paciente", $paciente);
  
 
  
   $this->assign("combo_sector", $this->getManager("ManagerSector")->getCombo(1));
   
     //Especialidades del profesional
  $managerEspecialidades = $this->getManager("ManagerEspecialidades");
    $combo_especialidades = $managerEspecialidades->getCombo(1);
  $this->assign("combo_especialidades", $combo_especialidades);
  
   if($_SESSION[URL_ROOT]["paciente_p"]['logged_account']["paciente"]["prestador_idprestador"]!=""){
      $this->assign("login_prestador",1);
  }
  
  

  
  
  
  
