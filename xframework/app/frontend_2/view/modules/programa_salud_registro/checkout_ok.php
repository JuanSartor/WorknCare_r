<?php

//recumeramos los registros mediante el hash encodado de usuario
$contratante = $this->getManager("ManagerUsuarioEmpresa")->getByHash($this->request["id"]);
$this->assign("contratante", $contratante);
$plan_contratado = $this->getManager("ManagerProgramaSaludPlan")->getByUserHash($this->request["id"]);
$this->assign("plan_contratado", $plan_contratado);
$suscripcion = $this->getManager("ManagerProgramaSaludSuscripcion")->getByField("empresa_idempresa", $contratante["empresa_idempresa"]);
$this->assign("suscripcion", $suscripcion);
$empresa = $this->getManager("ManagerEmpresa")->get($contratante["empresa_idempresa"]);
$this->assign("empresa", $empresa);