<?php

/**
 *  Motivos de Consulta Express
 *  
 * */
 
if (isset($this->request["id"]) && $this->request["id"] > 0) {
    $manager = $this->getManager("ManagerMotivoVideoConsulta");
    $record = $manager->get($this->request["id"]);

    $this->assign("record", $record);
    $listado_especialidades = $this->getManager("ManagerMotivoVideoConsultaEspecialidad")->getByMotivo($this->request["id"]);
    $this->assign("listado_especialidades", $listado_especialidades);

}


$this->assign("combo_especialidades", $this->getManager("ManagerEspecialidades")->getCombo());
