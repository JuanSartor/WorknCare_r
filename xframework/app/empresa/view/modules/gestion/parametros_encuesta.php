<?php

$ManagerProgramaSalud = $this->getManager("ManagerProgramaSalud");
$comboPrestaciones = $ManagerProgramaSalud->getComboProgramaPrestaciones();
$this->assign("combo_prestaciones", $comboPrestaciones);

$this->assign("idcuestionario", $this->request["cuestionarios_idcuestionario"]);

$Managerrecompensa = $this->getManager("ManagerRecompensa");
$comboRecompensas = $Managerrecompensa->getComboRecompensas();
$this->assign("combo_recompensas", $comboRecompensas);

$idempresa = $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["user"]["idempresa"];
$ManagerCuestionario = $this->getManager("ManagerCuestionario");
$cuestionario_enpreparacion = $ManagerCuestionario->getByFieldArray(["empresa_idempresa", "estado"], [$idempresa, 1]);

if ($cuestionario_enpreparacion) {
    $this->assign("cuestionario_enpreparacion", '1');
} else {
    $this->assign("cuestionario_enpreparacion", '0');
}
$this->assign("idempresa", $idempresa);
