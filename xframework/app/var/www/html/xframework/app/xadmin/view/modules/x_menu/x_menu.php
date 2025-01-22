<?php

$listado_usuario_acceso = $this->getManager("ManagerUsuarioAcceso")->getListAccesosByUsuario($_SESSION[URL_ROOT][CONTROLLER]['logged_account']["id"]);

$this->assign("listado_usuario_acceso", $listado_usuario_acceso);
