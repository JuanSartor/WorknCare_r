<?php

$idpaginate = "listado_usuarios_secundarios";


$this->assign("idpaginate", $idpaginate);
$Manager = $this->getManager("ManagerUsuarioEmpresa");
$listado_usuarios = $Manager->getListadoUsuariosSecundarios($this->request, $idpaginate);
$this->assign("listado_usuarios", $listado_usuarios);

if ($this->request["check"] == '') {
    $this->assign("check", '0');
} else {
    $this->assign("check", $this->request["check"]);
}

