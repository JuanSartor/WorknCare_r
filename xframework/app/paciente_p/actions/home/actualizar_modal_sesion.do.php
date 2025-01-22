<?php

/**
 *  Action para actualizar wizard_primer_inicio_sesion
 */
$Manager = $this->getManager("ManagerPaciente");
$result = $Manager->basic_update(["wizard_primer_inicio_sesion" => "0"], $_SESSION[URL_ROOT]["paciente_p"]['logged_account']["paciente"]["idpaciente"]);

if ($result) {
    echo true;
} else {
    echo false;
}
