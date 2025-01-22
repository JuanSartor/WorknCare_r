<?php

$managerUsu = $this->getManager("ManagerUsuarioWeb");

$ManagerMedico = $this->getManager("ManagerMedico");
//$ManagerMedico->debug();
$medico = $ManagerMedico->get($_SESSION[URL_ROOT][CONTROLLER]['logged_account']["medico"]["idmedico"]);

if ($medico) {

    $managerUsu->changePassword($this->request);
    $this->finish($managerUsu->getMsg());
} else {
    $this->finish(array(
        "result" => false,
        "msg" => "Ocurrió un error al modificar la contraseña, intentelo nuevamente."
    ));
}