<?php

 
  $idpaciente = $this->request["idpaciente"];
  
  $ManagerPerfilSaludAlergia = $this->getManager("ManagerPerfilSaludAlergia");
  $listado = $ManagerPerfilSaludAlergia->getInfoTablero($idpaciente);
  if($listado && count($listado) > 0){
      $this->assign("list_alergias", $listado);
  }