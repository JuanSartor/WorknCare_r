<?php

//actualizamos el contador de notificaciones
  $ManagerVideoConsulta = $this->getManager("ManagerVideoConsulta");
  
  $ManagerVideoConsulta->setNotificacionesLeidasMedico(["idestadoVideoConsulta" => 4]);

  $this->request["idestadoVideoConsulta"] = 4;

  $idmedico = $_SESSION[URL_ROOT][CONTROLLER]["logged_account"]["medico"]["idmedico"];

  $idpaginate = "listado_paginado_videoconsultas_finalizadas_{$idmedico}";
  $this->assign("idpaginate", $idpaginate);

  $listado = $ManagerVideoConsulta->getListadoPaginadoVideoConsultasMedico($this->request, $idpaginate);

  if (count($listado["rows"]) > 0) {
      $this->assign("listado_videoconsultas_finalizadas", $listado);
  }
  
    $this->request["idestadoVideoConsulta"] = 8; 
    $idpaginate2 = "listado_videoconsultas_pendientes_finalizacion{$idmedico}";
    $this->assign("idpaginate2", $idpaginate2);
   $listado_pendientes_finalizacion = $ManagerVideoConsulta->getListadoPaginadoVideoConsultasMedico($this->request,$idpaginate2);

  if (count($listado_pendientes_finalizacion["rows"]) > 0) {
      $this->assign("listado_videoconsultas_pendientes_finalizacion", $listado_pendientes_finalizacion);
      
  }
  //asignamos los filtro de la busqueda si vienen seteados
  if($this->request["filtro_inicio"]!=""){
      
      $this->assign("filtro_inicio",$this->request["filtro_inicio"]);
  }
  if($this->request["filtro_fin"]!=""){
      $this->assign("filtro_fin",$this->request["filtro_fin"]);
  }


  $cantidad_consulta = $ManagerVideoConsulta->getCantidadVideoConsultasMedicoXEstado();
  $this->assign("cantidad_consulta", $cantidad_consulta);
  