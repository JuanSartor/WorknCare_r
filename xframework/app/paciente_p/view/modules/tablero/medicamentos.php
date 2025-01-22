<?php

  $idpaciente = $this->request["idpaciente"];

  $ManagerPerfilSaludMedicamento = $this->getManager("ManagerPerfilSaludMedicamento");
  
  $listado = $ManagerPerfilSaludMedicamento->getInfoTablero($idpaciente);
  if ($listado && count($listado) > 0) {
      $this->assign("list_medicamentos", $listado);
  }
  
 