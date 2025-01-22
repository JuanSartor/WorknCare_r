<?php

$header_paciente = $_SESSION[URL_ROOT]["paciente_p"]['logged_account']["paciente"]["header_paciente"];

//Si el filtro es distinto de "self" o de "all" va el filter selected,que es el id del paciente perteneciente al paciente
$idpaciente = isset($header_paciente) && $header_paciente["filter_selected"] != "self" && $header_paciente["filter_selected"] != "all" ?
        $header_paciente["filter_selected"] :
        $_SESSION[URL_ROOT]["paciente_p"]['logged_account']["paciente"]["idpaciente"];

$ManagerPaciente = $this->getManager("ManagerPaciente");
$this->assign("paciente", $ManagerPaciente->get($idpaciente));

$this->assign("idpaciente", $idpaciente);

$ManagerPerfilSaludBiometrico = $this->getManager("ManagerPerfilSaludBiometrico");
$perfil_salud_biometrico = $ManagerPerfilSaludBiometrico->getByField("paciente_idpaciente", $idpaciente);

if ($perfil_salud_biometrico) {
    $ManagerMasaCorporal = $this->getManager("ManagerMasaCorporal");
    $masa_corporal = $ManagerMasaCorporal->getLastInformation($perfil_salud_biometrico["idperfilSaludBiometricos"]);
    if ($masa_corporal) {
        $this->assign("masa_corporal", $masa_corporal);
    }

    $this->assign("perfil_salud_biometrico", $perfil_salud_biometrico);
}
//actualizo el siguien step que se va a cargar

$this->getManager("ManagerPerfilSaludStatus")->update_wizard_step(1, $idpaciente);

