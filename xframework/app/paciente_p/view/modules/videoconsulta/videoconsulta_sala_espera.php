<?php

  
  //Consulta Pendiente
  $this->request["idestadoVideoConsulta"] = 2;

   $paciente = $this->getManager("ManagerPaciente")->getPacienteXHeader();
   $this->assign("paciente", $paciente);
 
  
  $idpaginate = "listado_paginado_videoconsultas_espera_" . $paciente["idpaciente"];
  $this->assign("idpaginate", $idpaginate);

  $ManagerVideoConsulta = $this->getManager("ManagerVideoConsulta");
//listado de consultas abiertas en espera
  $listado = $ManagerVideoConsulta->getListadoPaginadoVideoConsultasPaciente($this->request, $idpaginate);
  if (count($listado["rows"]) > 0) {
      $this->assign("listado_videoconsultas_espera", $listado);
    
     
     
  }
  
 
 
$cantidad_consulta = $ManagerVideoConsulta->getCantidadVideoConsultasPacienteXEstado();
  $this->assign("cantidad_consulta", $cantidad_consulta);
 
 