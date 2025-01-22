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

    $listado_programas_categorias = $this->getManager("ManagerMotivoVideoConsultaProgramaCategoria")->getByMotivo($this->request["id"]);
    $this->assign("listado_programas_categorias", $listado_programas_categorias);

}


$this->assign("combo_especialidades", $this->getManager("ManagerEspecialidades")->getCombo());
$this->assign("combo_programa_categoria", $this->getManager("ManagerProgramaSaludCategoria")->getComboCategorias());
