<?php

  
  //Consulta Pendiente
  $this->request["idestadoVideoConsulta"] = 7;

  $idmedico = $_SESSION[URL_ROOT][CONTROLLER]["logged_account"]["medico"]["idmedico"];
  $this->assign("idmedico", $idmedico);
 
  
  $idpaginate = "listado_paginado_videoconsultas_pendientes_finalizacion_$idmedico";
  $this->assign("idpaginate", $idpaginate);

  $ManagerVideoConsulta = $this->getManager("ManagerVideoConsulta");

  $listado = $ManagerVideoConsulta->getListadoPaginadoVideoConsultasPaciente($this->request, $idpaginate);

  if (count($listado["rows"]) > 0) {
          $this->assign("listado_videoconsultas_pendientes_finalizacion", $listado);
     
     
  }

  $cantidad_consulta = $ManagerVideoConsulta->getCantidadVideoConsultasPacienteXEstado();
  $this->assign("cantidad_consulta", $cantidad_consulta);
 
  
