<?php


  //Paciente que se encuentra en el array de SESSION de header paciente
  $ManagerPaciente = $this->getManager("ManagerPaciente");
  $paciente = $ManagerPaciente->getPacienteXHeader();
  $this->assign("paciente", $paciente);


  $paginate = "profesionales_favoritos_list";

  $this->assign("idpaginate", $paginate);
  
  //$ManagerPaciente->debug();
  $medicos_list = $ManagerPaciente->getMedicosFavoritosList($this->request, $paginate);



  if ($medicos_list) {
      $this->assign("medicos_list", $medicos_list);
    
  }

  
  
