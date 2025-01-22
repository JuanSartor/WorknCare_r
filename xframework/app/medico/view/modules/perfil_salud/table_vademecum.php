<?php

  $idpaginate = "list_vademecum";
  $this->assign("idpaginate_vademecum", $idpaginate);

  $this->assign("str", $this->request["str"]);
  
  $ManagerMedicamento = $this->getManager("ManagerMedicamento");
  $listado = $ManagerMedicamento->getListMedicamentosPaginado($this->request, $idpaginate);

  if ($listado) {
      $this->assign("list_vademecum", $listado);
  }
