<?php

  $idpaciente = $this->request["idpaciente"];

  $ManagerPerfilSaludCirugias = $this->getManager("ManagerPerfilSaludCirugias");
  
  $listado = $ManagerPerfilSaludCirugias->getInfoTablero($idpaciente);
  if ($listado && count($listado) > 0) {
      $this->assign("list_cirugias", $listado);
  }