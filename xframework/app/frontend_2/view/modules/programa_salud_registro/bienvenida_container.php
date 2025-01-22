<?php

//recumeramos los registros mediante el hash encodado de usuario
$contratante = $this->getManager("ManagerUsuarioEmpresa")->getByHash($this->request["hash"]);
$this->assign("contratante", $contratante);
$plan_contratado = $this->getManager("ManagerProgramaSaludPlan")->getByUserHash($this->request["hash"]);
$this->assign("plan_contratado", $plan_contratado);
$empresa = $this->getManager("ManagerEmpresa")->get($contratante["empresa_idempresa"]);
$this->assign("empresa", $empresa);
