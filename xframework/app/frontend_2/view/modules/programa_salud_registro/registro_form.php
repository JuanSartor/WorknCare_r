<?php

$this->assign("free", $this->request["free"]);

//flag si viene de la contratacion particular
if ($this->request["particular"] != '') {
    $this->assign("particular", 1);
    //obtenemos el listado de planes para particulares
    $planes = $this->getManager("ManagerProgramaSaludPlan")->getList(0, "particular");
    $this->assign("planes", $planes);
    $this->assign("planes", $planes);
//obtenemos el listado de packs para Obras Sociales
    $packs = $this->getManager("ManagerProgramaSaludPlan")->getList(1, "particular");
    usort($packs, 'sort_by_orden');
    $this->assign("packs", $packs);
} else {
    //obtenemos el listado de planes para particulares
    $planes = $this->getManager("ManagerProgramaSaludPlan")->getList(0, "empresa");
    usort($planes, 'sort_by_orden');
    $this->assign("planes", $planes);
//obtenemos el listado de packs para Obras Sociales
    $packs = $this->getManager("ManagerProgramaSaludPlan")->getList(1, "empresa");
    usort($packs, 'sort_by_orden');
    $this->assign("packs", $packs);
}

// esta es una funcion auxiliar para el metodo usort utilizado arriba
// lo que hago es ordenar los planes por su precio de menor a mayor
function sort_by_orden($a, $b) {
    return $a['precio'] - $b['precio'];
}

$this->assign("STRIPE_APIKEY_PUBLIC", STRIPE_APIKEY_PUBLIC);

//cargar modal login cuando es redirect y no se inció sesion
if (isset($this->request["connecter"]) || $_SESSION[URL_ROOT]["frontend_2"]["redirect"] != "") {
    $this->assign("show_login", 1);
}

if ($this->request["achatdepack"] != '') {
    $this->assign("achatdepack", $this->request["achatdepack"]);
} else {
    $this->assign("achatdepack", '0');
}
