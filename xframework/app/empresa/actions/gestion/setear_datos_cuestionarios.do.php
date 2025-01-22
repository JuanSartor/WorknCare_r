<?php

$idempresa = $this->request["idempresa"];
//print_r($this->request);
// aca entra porque esta por crear un cuestionarios con las mismas preguntas
if ($idempresa == '0') {
    $managerCustionario = $this->getManager("ManagerCuestionario");
    $managerCustionario->crearCuestionarioEmpresa($this->request);
    $this->finish($managerCustionario->getMsg());
} else {
    $fechainiexplode = explode("/", $this->request["fecha_inicio"]);
    $fechaI = $fechainiexplode[2] . "-" . $fechainiexplode[1] . "-" . $fechainiexplode[0];
    $this->request["fecha_inicio"] = date("Y-m-d", strtotime($fechaI));

    $fechafinexplode = explode("/", $this->request["fecha_fin"]);
    $fechaf = $fechafinexplode[2] . "-" . $fechafinexplode[1] . "-" . $fechafinexplode[0];
    $this->request["fecha_fin"] = date("Y-m-d", strtotime($fechaf));
    $managerCustionario = $this->getManager("ManagerCuestionario");
    $managerCustionario->update($this->request, $this->request["idcuestionario"]);
    $this->finish($managerCustionario->getMsg());
}    


