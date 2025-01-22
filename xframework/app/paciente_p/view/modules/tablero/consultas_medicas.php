<?php

  $idpaciente = $this->request["idpaciente"];

  $ManagerPerfilSaludConsulta = $this->getManager("ManagerPerfilSaludConsulta");
//  $ManagerPerfilSaludConsulta->debug();
  $listado = $ManagerPerfilSaludConsulta->getInfoTablero($idpaciente);
  if ($listado && count($listado) > 0) {
      $this->assign("list_consultas", $listado);
     
  }


        