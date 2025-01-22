<?php

  $ManagerMedicoMisPacientes = $this->getManager("ManagerMedicoMisPacientes");

  $idmedico = $_SESSION[URL_ROOT][CONTROLLER]["logged_account"]["medico"]["idmedico"];

  $paginate = "list_mis_pacientes_busqueda";
  $this->assign("idpaginate", $paginate . "_" . $idmedico);
  $listado = $ManagerMedicoMisPacientes->getListadoPaginadoMisPacientes($this->request, $paginate . "_" . $idmedico);

  $this->assign("query_str", $this->request["query_str"]);

  if (count($listado["rows"]) > 0) {
      $this->assign("listado_mis_pacientes", $listado);
      
  }
  
  