<?php

/**
 *  Categoria de los Programas de salud
 *  
 * */
if (isset($this->request["id"]) && $this->request["id"] > 0) {
    $manager = $this->getManager("ManagerProgramaSaludCategoria");
    $record = $manager->get($this->request["id"]);

    $this->assign("record", $record);

    $listado_motivos_vc = $this->getManager("ManagerMotivoVideoConsulta")->getComboByProgramaCategoria($this->request["id"]);
    $this->assign("listado_motivos_vc", $listado_motivos_vc);
    $listado_motivos_ce = $this->getManager("ManagerMotivoConsultaExpress")->getComboByProgramaCategoria($this->request["id"]);
    $this->assign("listado_motivos_ce", $listado_motivos_ce);
    $listado_motivos_visita = $this->getManager("ManagerMotivoVisita")->getComboByProgramaCategoria($this->request["id"]);
    $this->assign("listado_motivos_visita", $listado_motivos_visita);
}

if (isset($this->request["idprograma_salud"]) && $this->request["idprograma_salud"] > 0) {
    $manager = $this->getManager("ManagerProgramaSalud");
    $programa_salud = $manager->get($this->request["idprograma_salud"]);

    $this->assign("programa_salud", $programa_salud);
}
