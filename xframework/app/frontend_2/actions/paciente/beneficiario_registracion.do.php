<?php

/** 	
 * 	Accion: Registración de los pacientes
 * 	
 */
$this->start();
$manager = $this->getManager("ManagerPaciente");
$managerPacienteEmpresa = $this->getManager("ManagerPacienteEmpresa");
$managerEmpresa = $this->getManager("ManagerEmpresa");

// esto agregue el 13-04-2023 para setear el idioma predeterminado
if ($this->request["idioma_pre"] == '1') {
    $this->request["idioma_predeterminado"] = "fr";
} else {
    $this->request["idioma_predeterminado"] = "en";
}

// el if este agregue para que si la cuenta existe y fue invitado debo crear la parte
// de beneficiario a una empresa  y no hacerlo desde cero como va por el else
if ($this->request["banderaBeneficiarioExistente"] == '1') {
    $rdo = $manager->registracion_beneficiario_step1($this->request);
    if ($rdo) {
        $usWeb = $this->getManager("ManagerUsuarioWeb")->getByField("email", $this->request["email"]);
        $paciente = $manager->getByField("usuarioweb_idusuarioweb", $usWeb["idusuarioweb"]);
        $this->request["idpaciente"] = $paciente["idpaciente"];
        $manager->registracion_beneficiario_step3($this->request);
    }
    $this->finish($manager->getMsg());
} else {
    $result = $manager->registracion_beneficiario($this->request);

    // esto y lo que esta dentro del if agregue el 06/10/2022
    // fue para lo de la validacion automatica del lado empresa
    if ($this->request["step"] == '3') {
        $pacieEmpresa = $managerPacienteEmpresa->getByField("paciente_idpaciente", $this->request["idpaciente"]);
        $empresa = $managerEmpresa->get($pacieEmpresa["empresa_idempresa"]);
        if ($empresa["validacion_automatica"] == '1') {
            $manUe = $this->getManager("ManagerUsuarioEmpresa");
            $usContratante = $manUe->getUsuarioContratante($empresa["idempresa"]);
            $this->request["front"] = $usContratante["idusuario_empresa"];
            $this->request["estado"] = 1;
            $this->request["ids"] = $pacieEmpresa["idpaciente_empresa"];
            $manager = $this->getManager("ManagerPacienteEmpresa");
            $manager->cambiar_estado($this->request);
        }
    }

    $this->finish($manager->getMsg());
}
?>
