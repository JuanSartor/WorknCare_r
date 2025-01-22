<?php

 $idpaginate = "list_enfermedad_cie10";
  $this->assign("idpaginate_enfermedad_cie10", $idpaginate);

  $this->assign("str", $this->request["str"]);
  
  $ManagerMedicamento = $this->getManager("ManagerImportacionCIE10");
  $listado = $ManagerMedicamento->getListEnfermedadesCIE10Paginado($this->request, $idpaginate);

  if ($listado) {
      $this->assign("list_enfermedad_cie10", $listado);
  }