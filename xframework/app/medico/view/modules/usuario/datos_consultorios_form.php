<?php

$managerPais = $this->getManager("ManagerPais");
$paises = $managerPais->getCombo();
$this->assign("combo_pais", $paises);
$idmedico = $_SESSION[URL_ROOT][CONTROLLER]["logged_account"]["medico"]["idmedico"];
if (isset($this->request["idconsultorio"]) && (int) $this->request["idconsultorio"] > 0) {
    $managerConsultorio = $this->getManager("ManagerConsultorio");
    $consultorio = $managerConsultorio->get($this->request["idconsultorio"]);
    $this->assign("record", $consultorio);
}
$ManagerPreferencia = $this->getManager("ManagerPreferencia");
$preferencia = $ManagerPreferencia->getPreferenciaMedico($idmedico);

$this->assign("preferencia", $preferencia);
$this->assign("combo_duracion_turnos", $ManagerPreferencia->getComboDuracionTurnos());
//obtenemos la configuracion de intervalos de tiempo
$ManagerConfiguracionAgenda = $this->getManager("ManagerConfiguracionAgenda");
$combo_horarios = $ManagerConfiguracionAgenda->getComboHorarioMinutos($idmedico);
$this->assign("horas_minutos", $combo_horarios);

$ManagerMedico = $this->getManager("ManagerMedico");
$medico = $ManagerMedico->get($idmedico, true);

$this->assign("medico", $medico);





