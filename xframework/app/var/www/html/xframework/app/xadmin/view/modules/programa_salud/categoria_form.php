<?php

/**
 *  Categoria de los Programas de salud
 *  
 * */

if (isset($this->request["id"]) && $this->request["id"] > 0) {
    $manager = $this->getManager("ManagerProgramaSaludCategoria");
    $record = $manager->get($this->request["id"]);

    $this->assign("record", $record);

}

if (isset($this->request["idprograma_salud"]) && $this->request["idprograma_salud"] > 0) {
    $manager = $this->getManager("ManagerProgramaSalud");
    $programa_salud = $manager->get($this->request["idprograma_salud"]);

    $this->assign("programa_salud", $programa_salud);
}
