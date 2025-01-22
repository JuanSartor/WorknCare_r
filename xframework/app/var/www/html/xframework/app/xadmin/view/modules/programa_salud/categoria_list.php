<?php
/**
 *
 *  Categorias de los Programas de salud
 *
 */

$manager = $this -> getManager("ManagerProgramaSaludCategoria");

$paginate = SmartyPaginate::getPaginate($manager->getDefaultPaginate()."_".$this->request["idprograma_salud"]);

$this -> assign("paginate", $paginate);

if (isset($this->request["idprograma_salud"]) && $this->request["idprograma_salud"] > 0) {
    $manager = $this->getManager("ManagerProgramaSalud");
    $programa_salud = $manager->get($this->request["idprograma_salud"]);

    $this->assign("programa_salud", $programa_salud);
}

