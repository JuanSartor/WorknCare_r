<?php

//print_r($listado_medicos_referentes);
$ManagerProgramaSaludMedicoComplementario = $this->getManager("ManagerProgramaSaludMedicoComplementario");

$listado_medicos_complementarios = $ManagerProgramaSaludMedicoComplementario->getListadoMedicos(["idprograma_categoria" => $this->request["idprograma_categoria"]]);
$this->assign("listado_medicos_complementarios", $listado_medicos_complementarios);
$combo_medicos_complementarios = $ManagerProgramaSaludMedicoComplementario->getComboMedicos(["idprograma_categoria" => $this->request["idprograma_categoria"]]);
$this->assign("combo_medicos_complementarios", $combo_medicos_complementarios);
