<?php


  //Paciente que se encuentra en el array de SESSION de header paciente
  $ManagerPaciente = $this->getManager("ManagerPaciente");
  $paciente = $ManagerPaciente->getPacienteXHeader();
  $pacienteTitular=$ManagerPaciente->getPacienteTitular($paciente["idpaciente"]);

  $this->assign("pacienteTitular", $pacienteTitular);


  //obtenemos la consulta

   if(isset($this->request["idconsultaExpress"])&&$this->request["idconsultaExpress"]!=""){
    
      $ConsultaExpress=$this->getManager("ManagerConsultaExpress")->get($this->request["idconsultaExpress"]);
       $this->assign("ConsultaExpress", $ConsultaExpress);

  
  }

  
