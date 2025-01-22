<?php

/**
 *  elimino el registro de la tabla pregunta asociado a un cuestionario
 */
$this->start();

if ($this->request["cerrada"] == '1') {
    $manager = $this->getManager("ManagerPregunta");

// $manager->debug();
    $result = $manager->delete($this->request["idpregunta"], true);
    $this->finish($manager->getMsg());
} else {
    $managerA = $this->getManager("ManagerPreguntaAbierta");

// $manager->debug();
    $result = $managerA->delete($this->request["idpregunta"], true);
    $this->finish($managerA->getMsg());
}
   
