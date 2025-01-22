<?php
  //Consulta Pendiente
  $this->request["idestadoConsultaExpress"] = 8;

  $idmedico = $_SESSION[URL_ROOT][CONTROLLER]["logged_account"]["medico"]["idmedico"];
  $this->assign("idmedico", $idmedico);
 
  
  $idpaginate = "listado_paginado_consultas_pendientes_finalizacion_$idmedico";
  $this->assign("idpaginate", $idpaginate);

  $ManagerConsultaExpress = $this->getManager("ManagerConsultaExpress");

  $listado = $ManagerConsultaExpress->getListadoPaginadoConsultasExpressMedico($this->request, $idpaginate);

  if (count($listado["rows"]) > 0) {
      $this->assign("listado_consultas_pendientes_finalizacion", $listado);
     
  }

  $cantidad_consulta = $ManagerConsultaExpress->getCantidadConsultasExpressMedicoXEstado();
  $this->assign("cantidad_consulta", $cantidad_consulta);
 

