<?php

  //Consulta Abierta
  $this->request["idestadoConsultaExpress"] = 2;

  $idmedico = $_SESSION[URL_ROOT][CONTROLLER]["logged_account"]["medico"]["idmedico"];
  $this->assign("idmedico", $idmedico);
  
  $idpaginate = "listado_paginado_consultas_abiertas_{$idmedico}";
  $this->assign("idpaginate", $idpaginate);

  $ManagerConsultaExpress = $this->getManager("ManagerConsultaExpress");

  $listado = $ManagerConsultaExpress->getListadoPaginadoConsultasExpressMedico($this->request, $idpaginate);

  if (count($listado["rows"]) > 0) {
      $this->assign("listado_consultas_abiertas", $listado);
  }

  $cantidad_consulta = $ManagerConsultaExpress->getCantidadConsultasExpressMedicoXEstado();
  $this->assign("cantidad_consulta", $cantidad_consulta);
  
  $this->assign("url_audio", URL_ROOT . "xframework/files/temp/audio/blob.ogg");