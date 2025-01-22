<?php

$usuario = $this->getManager("ManagerUsuarioEmpresa")->get($_SESSION[URL_ROOT]["empresa"]['logged_account']["user"]["idusuario_empresa"]);
$this->assign("usuario", $usuario);

$empresa = $this->getManager("ManagerEmpresa")->getByField("idempresa", $usuario["empresa_idempresa"]);
$this->assign("empresa", $empresa);
