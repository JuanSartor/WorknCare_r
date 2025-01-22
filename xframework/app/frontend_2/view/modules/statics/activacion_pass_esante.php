<?php

//$this->start();
$manager = $this->getManager("ManagerUsuarioEmpresa");
//verifricamos si es usuario contratante o secundario
$usuario_secundario = $manager->getByFieldArray(["checkemail", "contratante", "estado"], [$this->request["hash"], 0, 0]);

if ($usuario_secundario["idusuario_empresa"] != "") {
    $this->assign("usuario_secundario", $usuario_secundario);
} else {
    $rdo = $manager->processActivacion($this->request);
    $msg = $manager->getMsg();
    $this->assign("respuesta_activacion", $msg);
}

//buscamos si el usuario contrato el pass como particular
$usuario = $manager->getByFieldArray(["checkemail"], [$this->request["hash"]]);

$empresa = $this->getManager("ManagerEmpresa")->get($usuario["empresa_idempresa"]);

if ($empresa["tipo_cuenta"] == 2) {
    $this->assign("particular", 1);
}

$this->assign("empresa", $empresa);
