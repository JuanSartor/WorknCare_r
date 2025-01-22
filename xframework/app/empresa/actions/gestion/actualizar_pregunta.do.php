<?php

/**
 *  actualizo la pregunta y tambien si hay algo en los inputs lo guardo
 */
if ($this->request["id_empresa"] != '0') {
    // aca entra si ya esta en un cuestionario propio   
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

    // aca entra si la nueva version a actualizar es una pregunta cerrada
    if ($this->request["rtaCerrada"] == 'true') {
        // ingresa aca si la pregunta en un principio era cerrada
        if ($this->request["primerRta"] == 'cerrada') {

            $managerPregunta = $this->getManager("ManagerPregunta");
            $managerPregunta->update($this->request, $this->request["idpregunta"]);
            $this->finish($managerPregunta->getMsg());
        } else { // ingresa aca si la pregunta al principio era abierta y ahora va a pasar a ser cerrada
            // elimino la pregunta abierta y despues inserto la pregunta cerrada
            $managerPreguntaAbierta = $this->getManager("ManagerPreguntaAbierta");
            $managerPreguntaAbierta->delete($this->request["idpregunta"]);
            $managerPregunta = $this->getManager("ManagerPregunta");
            $rqInsert["pregunta"] = $this->request["pregunta"];
            $rqInsert["cuestionarios_idcuestionario"] = $this->request["idcuestionario"];
            $managerPregunta->insertPregCerrada($rqInsert);
            $this->finish($managerPregunta->getMsg());
        }
    }
    // aca entra si la nueva version a actualizar es una pregunta abierta
    else {
        // ingresa aca si la pregunta en un principio era cerrada
        if ($this->request["primerRta"] == 'cerrada') {

            // elimino la pregunta cerrada e inserto la abierta nueva
            $managerPregunta = $this->getManager("ManagerPregunta");
            $managerPregunta->delete($this->request["idpregunta"]);
            $managerPreguntaAbierta = $this->getManager("ManagerPreguntaAbierta");
            $rqInsert["pregunta"] = $this->request["pregunta"];
            $rqInsert["cuestionario_idcuestionario"] = $this->request["idcuestionario"];
            $managerPreguntaAbierta->insertPregAbierta($rqInsert);
            $this->finish($managerPreguntaAbierta->getMsg());
        } else { // ingresa aca si la pregunta al principio era abierta y va a seguir siendo abierta
            $managerPreguntaAbierta = $this->getManager("ManagerPreguntaAbierta");
            $managerPreguntaAbierta->update($this->request, $this->request["idpregunta"]);
            $this->finish($managerPreguntaAbierta->getMsg());
        }
    }
} else {
    // aca entra cuando edita una pregunta de un cuestionario generico
    // entonces tengo que crear otro cuestionario con las preguntas del generico
    // menos la que edito que tengo q poner la editada
    $managerCustionario = $this->getManager("ManagerCuestionario");
    $managerCustionario->crearCuestionarioEmpresaConEdicionDeGenerico($this->request);
    $this->finish($managerCustionario->getMsg());
}
