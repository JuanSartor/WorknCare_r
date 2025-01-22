<?php

//recumeramos los registros mediante el hash encodado de usuario
$contratante = $this->getManager("ManagerUsuarioEmpresa")->get($_SESSION[URL_ROOT]["empresa"]['logged_account']["id"]);
$this->assign("contratante", $contratante);
$plan_contratado = $this->getManager("ManagerProgramaSaludPlan")->getByUserHash($contratante["hash"]);
$this->assign("plan_contratado", $plan_contratado);

$idempresa = $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["user"]["idempresa"];
$empresa = $this->getManager("ManagerEmpresa")->get($idempresa);
$this->assign("empresa", $empresa);
