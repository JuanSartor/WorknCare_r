<?php

/**
 *  elimino la pregunto y actualizo si hay algun input con algun dato
 */
$idp = $this->request["idpregunta"];
if ($this->request["idempresa"] != '0') {
    if ($this->request["fecha_inicio"] != '') {
        $fechainiexplode = explode("/", $this->request["fecha_inicio"]);
        $fechaI = $fechainiexplode[2] . "-" . $fechainiexplode[1] . "-" . $fechainiexplode[0];
        $this->request["fecha_inicio"] = date("Y-m-d", strtotime($fechaI));
    }
    if ($this->request["fecha_fin"] != '') {
        $fechafinexplode = explode("/", $this->request["fecha_fin"]);
        $fechaf = $fechafinexplode[2] . "-" . $fechafinexplode[1] . "-" . $fechafinexplode[0];
        $this->request["fecha_fin"] = date("Y-m-d", strtotime($fechaf));
    }

    $managerCustionario = $this->getManager("ManagerCuestionario");
    $managerCustionario->update($this->request, $this->request["cuestionarios_idcuestionario"]);
    // esto es xq si es distinto de 0 ya esta en un cuestionario propio
    if (strstr($idp, 'cerrada') != false) {
        $pieces = explode("-", $idp);
        $request["idpregunta"] = $pieces[1];
        $managerPregunta = $this->getManager("ManagerPregunta");
        $request["cuestionarios_idcuestionario"] = $this->request["cuestionarios_idcuestionario"];
        $managerPregunta->eliminarUnaPregunta($request);
        $this->finish($managerPregunta->getMsg());
    } else {
        $pieces = explode("-", $idp);
        $request["idpregunta_abierta_cuestionario"] = $pieces[1];
        $managerPreguntaAbierta = $this->getManager("ManagerPreguntaAbierta");
        $request["cuestionarios_idcuestionario"] = $this->request["cuestionarios_idcuestionario"];
        $managerPreguntaAbierta->eliminarUnaPregunta($request);
        $this->finish($managerPreguntaAbierta->getMsg());
    }
} else {
    $managerCustionario = $this->getManager("ManagerCuestionario");
    $managerCustionario->crearCuestionarioEmpresaConEliminacion($this->request);
    $this->finish($managerCustionario->getMsg());
}



