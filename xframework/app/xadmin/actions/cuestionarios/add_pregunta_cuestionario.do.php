<?php

/**
 *  agrego una pregunta al cuestionario
 */
$this->start();
if ($this->request["cerrada"] == '1') {
    $manager = $this->getManager("ManagerPregunta");
//$manager->debug();
    $result = $manager->insert($this->request);
    $this->finish($manager->getMsg());
} else {
    $managerA = $this->getManager("ManagerPreguntaAbierta");
    $request["pregunta"] = $this->request["pregunta"];
$request["orden"] = $this->request["orden"];
    $request["pregunta_en"] = $this->request["pregunta_en"];
    $request["cuestionario_idcuestionario"] = $this->request["cuestionarios_idcuestionario"];
    $result = $managerA->process($request);
    $this->finish($managerA->getMsg());
}
