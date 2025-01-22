<?php

/**
 *  Action para actualizar la columna wizard_primer_inicio_sesion en pacietne
 */
$Manager = $this->getManager("ManagerPaciente");
$result = $Manager->basic_update(["wizard_primer_inicio_sesion" => "1"], $_SESSION[URL_ROOT]["paciente_p"]['logged_account']["paciente"]["idpaciente"]);
$this->finish($Manager->getMsg());


