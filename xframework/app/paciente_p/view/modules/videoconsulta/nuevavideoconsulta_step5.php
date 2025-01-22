<?php


  //Paciente que se encuentra en el array de SESSION de header paciente
  $ManagerPaciente = $this->getManager("ManagerPaciente");
  $paciente = $ManagerPaciente->getPacienteXHeader();
  $pacienteTitular=$ManagerPaciente->getPacienteTitular($paciente["idpaciente"]);

  $this->assign("pacienteTitular", $pacienteTitular);


  //obtenemos la consulta

   if(isset($this->request["idvideoconsulta"])&&$this->request["idvideoconsulta"]!=""){
    
      $VideoConsulta=$this->getManager("ManagerVideoConsulta")->get($this->request["idvideoconsulta"]);
       $this->assign("VideoConsulta", $VideoConsulta);

  
  }

  
