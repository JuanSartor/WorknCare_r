<?php

//recumeramos los registros mediante el hash encodado de usuario
$contratante = $this->getManager("ManagerUsuarioEmpresa")->getByHash($this->request["pass_esante"]);
$this->assign("contratante", $contratante);

$empresa = $this->getManager("ManagerEmpresa")->get($contratante["empresa_idempresa"]);
$this->assign("empresa", $empresa);
