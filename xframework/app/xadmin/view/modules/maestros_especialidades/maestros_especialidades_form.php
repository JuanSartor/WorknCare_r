<?php

/**
 *  Obras Sociales / Prepaga >>  Alta 
 *  
 * */
if (isset($this->request["id"]) && $this->request["id"] > 0) {
    $manager = $this->getManager("ManagerEspecialidades");
    $record = $manager->get($this->request["id"]);

    $this->assign("record", $record);

    $listado_motivos_vc = $this->getManager("ManagerMotivoVideoConsulta")->getComboByEspecialidad($this->request["id"]);
    $this->assign("listado_motivos_vc", $listado_motivos_vc);
    $listado_motivos_ce = $this->getManager("ManagerMotivoConsultaExpress")->getComboByEspecialidad($this->request["id"]);
    $this->assign("listado_motivos_ce", $listado_motivos_ce);
    $listado_motivos_visita = $this->getManager("ManagerMotivoVisita")->getComboByEspecialidad($this->request["id"]);
    $this->assign("listado_motivos_visita", $listado_motivos_visita);
}
?>