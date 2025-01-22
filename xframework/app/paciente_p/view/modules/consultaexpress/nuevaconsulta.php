<?php


  //Paciente que se encuentra en el array de SESSION de header paciente
  $ManagerPaciente = $this->getManager("ManagerPaciente");
  $paciente = $ManagerPaciente->getPacienteXHeader();
  $this->assign("paciente", $paciente);

  //obtenemos la consulta express
    $ConsultaExpress=$this->getManager("ManagerConsultaExpress")->getConsultaExpressBorrador($paciente["idpaciente"]);
       $this->assign("ConsultaExpress", $ConsultaExpress);
       
       //si la consulta es de prefesionales en la red verificamos si ya se han creado los filtros de busqueda
       if($ConsultaExpress["consulta_step"]=="2"&&$ConsultaExpress["tipo_consulta"]=="0"){
           $filtro=$this->getManager("ManagerFiltrosBusquedaConsultaExpress")->getByField("consultaExpress_idconsultaExpress", $ConsultaExpress["idconsultaExpress"]);
      $this->assign("filtro",$filtro);
           }

    $cantidad_consulta = $this->getManager("ManagerConsultaExpress")->getCantidadConsultasExpressPacienteXEstado();
  $this->assign("cantidad_consulta", $cantidad_consulta);
  
 if($_SESSION[URL_ROOT]["paciente_p"]['logged_account']["paciente"]["prestador_idprestador"]!=""){
      $this->assign("login_prestador",1);
  }