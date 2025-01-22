<?php

//print_r($this->request);

if ($this->request["idempresa"] == '0' || $this->request["idempresa"] == '') {

    $managerCustionario = $this->getManager("ManagerCuestionario");
    $managerCustionario->crearCuestionarioEmpresa($this->request);
    $this->finish($managerCustionario->getMsg());
} else {
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
    $managerCustionario->update($this->request, $this->request["idcuestionario"]);

    if ($this->request["rtaCerrada"] == 'true') {
        $managerPregunta = $this->getManager("ManagerPregunta");
        $request["pregunta"] = $this->request["nuevaPregunta"];
        $request["cuestionarios_idcuestionario"] = $this->request["idcuestionario"];
        $managerPregunta->insertUnaPregunta($request);
    } else {
        $managerPregunta = $this->getManager("ManagerPreguntaAbierta");
        $request["pregunta"] = $this->request["nuevaPregunta"];
        $request["cuestionario_idcuestionario"] = $this->request["idcuestionario"];
        $managerPregunta->insertUnaPregunta($request);
    }


    $this->finish($managerPregunta->getMsg());
}