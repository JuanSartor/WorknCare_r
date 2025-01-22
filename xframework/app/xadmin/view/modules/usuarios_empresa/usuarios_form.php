<?php

/**
 *  Perfiles - Nuevo/Editar
 * 
 * */
$manager = $this->getManager("ManagerUsuarioEmpresa");

if (isset($this->request["id"]) && $this->request["id"] > 0) {

    $usuario = $manager->getByFieldArray(["empresa_idempresa", "contratante"], [$this->request["id"], 1]);
    //obtenemos el usuario full info con empresa
    $record = $manager->get($usuario["idusuario_empresa"]);
    $this->assign("record", $record);
}

$this->assign("plan", $this->getManager("ManagerProgramaSaludPlan")->get($record["plan_idplan"]));

$ManagerPacienteEmpresa = $this->getManager("ManagerPacienteEmpresa");

$paginate = SmartyPaginate::getPaginate($ManagerPacienteEmpresa->getDefaultPaginate() . "_" . $this->request["id"]);

$info_beneficiarios = $this->getManager("ManagerPacienteEmpresa")->getInfoBeneficiariosInscriptos($this->request["id"]);
$this->assign("info_beneficiarios", $info_beneficiarios);

$this->assign("paginate", $paginate);

$ManagerEmbajador = $this->getManager("ManagerEmbajador");
$this->assign("combo_embajadores", $ManagerEmbajador->getCombo());

$ManagerEmpresa = $this->getManager("ManagerEmpresa");
$this->assign("empresa", $ManagerEmpresa->get($this->request["id"]));

$ManagerProgramaSaludSuscripcion = $this->getManager("ManagerProgramaSaludSuscripcion");
$this->assign("programaSaludSuscripcion", $ManagerProgramaSaludSuscripcion->getByField("empresa_idempresa", $this->request["id"]));
?>