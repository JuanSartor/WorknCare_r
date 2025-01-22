<?php

$idempresa = $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["user"]["idempresa"];
$this->start();
$ma = $this->getManager("ManagerEmpresa");
$ma->generarQRinvitacion($idempresa);
$this->finish($ma->getMsg());
