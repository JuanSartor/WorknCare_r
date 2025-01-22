<?php

  
  //Consulta en curso o interrumpidas
  $this->request["idestadoVideoConsulta"] = 7;

  $idmedico = $_SESSION[URL_ROOT][CONTROLLER]["logged_account"]["medico"]["idmedico"];
  $this->assign("idmedico", $idmedico);
 
  
  $idpaginate = "listado_videoconsultas_interrumpidas_$idmedico";
  $this->assign("idpaginate", $idpaginate);

  $ManagerVideoConsulta = $this->getManager("ManagerVideoConsulta");

  $listado = $ManagerVideoConsulta->getListadoPaginadoVideoConsultasMedico($this->request, $idpaginate);

  if (count($listado["rows"]) > 0) {
          $this->assign("listado_videoconsultas_interrumpidas", $listado);
  }


  $cantidad_consulta = $ManagerVideoConsulta->getCantidadVideoConsultasMedicoXEstado();
  $this->assign("cantidad_consulta", $cantidad_consulta);
