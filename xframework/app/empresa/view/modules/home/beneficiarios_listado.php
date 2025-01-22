<?php

$idpaginate = "listado_beneficiarios";


$this->assign("idpaginate", $idpaginate);
$Manager = $this->getManager("ManagerPacienteEmpresa");
$listado_beneficiarios = $Manager->getListadoBeneficiarios($this->request, $idpaginate);
$this->assign("listado_beneficiarios", $listado_beneficiarios);

