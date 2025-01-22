<?php

$managerUsu = $this->getManager("ManagerUsuarioWeb");

$ManagerPaciente = $this->getManager("ManagerPaciente");
//$ManagerPaciente->debug();
$paciente = $ManagerPaciente->get($_SESSION[URL_ROOT][CONTROLLER]['logged_account']["paciente"]["idpaciente"]);

if ($paciente) {

    $managerUsu->changePassword($this->request);
    $this->finish($managerUsu->getMsg());
} else {
    $this->finish(array(
        "result" => false,
        "msg" => "Ocurrió un error al modificar la contraseña, intentelo nuevamente."
    ));
}