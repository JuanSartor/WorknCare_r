<?php


  $ManagerConsultaExpress=$this->getManager("ManagerConsultaExpress");
 
  $cantidad_consulta=$ManagerConsultaExpress->getCantidadConsultasExpressMedicoXEstado();
  $this->assign("cantidad_consulta",$cantidad_consulta);
  
  
  $this->request["idestadoConsultaExpress"] = 8;
  
   $idpaginate = "listado_consultas_pendientes_finalizacion{$idmedico}";
   $this->assign("idpaginate", $idpaginate);
   $listado_pendientes_finalizacion = $ManagerConsultaExpress->getListadoPaginadoConsultasExpressMedico($this->request, $idpaginate);

  if (count($listado_pendientes_finalizacion["rows"]) > 0) {
      $this->assign("listado_consultas_pendientes_finalizacion", $listado_pendientes_finalizacion);
      
  }