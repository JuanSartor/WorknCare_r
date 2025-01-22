<?php

$ManagerProgramaSaludMedicoReferente = $this->getManager("ManagerProgramaSaludMedicoReferente");
$listado_medicos_referentes = $this->getManager("ManagerProgramaSaludMedicoReferente")->getListadoMedicos(["idprograma_categoria" => $this->request["idprograma_categoria"]]);
$this->assign("listado_medicos_referentes", $listado_medicos_referentes);

$combo_medicos_referentes = $ManagerProgramaSaludMedicoReferente->getComboMedicos(["idprograma_categoria" => $this->request["idprograma_categoria"]]);
$this->assign("combo_medicos_referentes", $combo_medicos_referentes);

