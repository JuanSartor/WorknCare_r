<?php

  $ManagerMedicoMisPacientes = $this->getManager("ManagerMedicoMisPacientes");

  $idmedico = $_SESSION[URL_ROOT][CONTROLLER]["logged_account"]["medico"]["idmedico"];

  $paginate = "list_mis_pacientes_sincargo";
  $this->assign("idpaginate", $paginate . "_" . $idmedico);
  $this->assign("idmedico",$idmedico);
//  $ManagerMedicoMisPacientes->debug();
  $sin_cargo=true;
  $listado = $ManagerMedicoMisPacientes->getListadoPaginadoMisPacientes($this->request, $paginate . "_" . $idmedico,$sin_cargo);

  if (count($listado["rows"]) > 0) {
      $this->assign("listado_mis_pacientes_sincargo", $listado);
   
  }
  
