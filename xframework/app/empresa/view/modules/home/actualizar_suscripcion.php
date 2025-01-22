<?php

$plan_contratado = $this->getManager("ManagerProgramaSaludPlan")->getByUser($_SESSION[URL_ROOT]["empresa"]['logged_account']["id"]);
$this->assign("plan_contratado", $plan_contratado);
if ($plan_contratado["pack"] == '1') {
    $planes = $this->getManager("ManagerProgramaSaludPlan")->getList(1);
} else {
    $planes = $this->getManager("ManagerProgramaSaludPlan")->getList();
}

usort($planes, 'sort_by_orden');
$this->assign("planes", $planes);

function sort_by_orden($a, $b) {
    return $a['precio'] - $b['precio'];
}

$empresa = $this->getManager("ManagerEmpresa")->get($_SESSION[URL_ROOT]["empresa"]['logged_account']["id"]);
$this->assign("empresa", $empresa);
