<?php

if ($_COOKIE["user"] != "") {
    $enc = new CookieEncrypt(ENCRYPT_KEY);
    $user = $enc->get_cookie("user");

    $arr = unserialize($user);

    if ($arr["tipo_usuario"] == "medico") {
        $manager = $this->getManager("ManagerMedico");

        $medico = $manager->get($arr["id"]);
        $medico["image"] = $manager->getImagenMedico($medico["idmedico"]);
        //print_r($medico);
        $this->assign("usuario", $medico);
    } else {
        $manager = $this->getManager("ManagerPaciente");

        $paciente = $manager->get($arr["id"]);

        $this->assign("usuario", $paciente);
    }
    $this->assign("timeout_modal", 1);
}
$this->assign("combo_prestador", $this->getManager("ManagerPrestador")->getComboLoginPrestador());
//Especialidades del profesional
$managerEspecialidades = $this->getManager("ManagerEspecialidades");
$combo_especialidades = $managerEspecialidades->getCombo(1);
$this->assign("combo_especialidades", $combo_especialidades);
//cargar modal login cuando es redirect y no se inció sesion
if (isset($_SESSION[URL_ROOT]["frontend_2"]["redirect"]) && $_SESSION[URL_ROOT]["frontend_2"]["redirect"] != "") {
    $this->assign("show_login", 1);
    if (isset($_SESSION[URL_ROOT]["frontend_2"]["redirect"]) && $_SESSION[URL_ROOT]["frontend_2"]["redirect_controller"] == "medico") {
        $this->assign("tipousuario", "medico");
    } else if (isset($_SESSION[URL_ROOT]["frontend_2"]["redirect"]) && $_SESSION[URL_ROOT]["frontend_2"]["redirect_controller"] == "paciente_p") {
        $this->assign("tipousuario", "paciente");
    }
}


$listado_programas = $this->getManager("ManagerProgramaSalud")->getListadoProgramas();
$this->assign("listado_programas", $listado_programas);
