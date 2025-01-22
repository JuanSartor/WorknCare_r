<?php

  $ManagerPaciente = $this->getManager("ManagerPaciente");
//$ManagerPaciente->debug();
  $idmedico = $_SESSION[URL_ROOT][CONTROLLER]["logged_account"]["medico"]["idmedico"];

  $paginate = "list_all_pacientes";
  $this->assign("idpaginate", $paginate . "_" . $idmedico);
  $listado = $ManagerPaciente->getListadoPaginadoAllPacientesDP($this->request, $paginate . "_" . $idmedico);

  $this->assign("query_str", $this->request["query_str"]);

  if (count($listado["rows"]) > 0) {
      $this->assign("listado_mis_pacientes", $listado);
    
  }

  