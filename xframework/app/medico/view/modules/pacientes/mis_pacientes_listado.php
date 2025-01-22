<?php

$ManagerMedicoMisPacientes = $this->getManager("ManagerMedicoMisPacientes");
$idmedico = $_SESSION[URL_ROOT][CONTROLLER]["logged_account"]["medico"]["idmedico"];

$paginate = "list_mis_pacientes";
$this->assign("idpaginate", $paginate . "_" . $idmedico);
//  $ManagerMedicoMisPacientes->debug();
$listado = $ManagerMedicoMisPacientes->getListadoPaginadoMisPacientes($this->request, $paginate . "_" . $idmedico);

if (count($listado["rows"]) > 0) {
    $this->assign("listado_mis_pacientes", $listado);
    if ($_SERVER["REMOTE_ADDR"] == "152.170.162.5") {
        //print_r($listado);
    }
}
  
