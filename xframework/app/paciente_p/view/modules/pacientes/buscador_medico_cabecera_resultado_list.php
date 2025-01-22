<?php

$ManagerMedico = $this->getManager("ManagerMedico");

$idpaginate = "medico_cabecera_resultado_list";
$listado = $ManagerMedico->getMedicosListFromBusquedaPaginado($this->request, $idpaginate);

$this->assign("listado_medicos", $listado);
//print_r($listado);
