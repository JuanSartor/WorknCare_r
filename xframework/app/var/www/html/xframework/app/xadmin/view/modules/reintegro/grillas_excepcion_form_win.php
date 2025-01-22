<?php

  /**
   *  Obtenemos el listado de excepciones a las grillas
   *  
   * */
if (isset($this->request["id"]) && $this->request["id"] > 0) {
    $manager = $this->getManager("ManagerGrillaExcepcion");
    $record = $manager->get($this->request["id"]);

    $this->assign("record", $record);

}
  
$ManagerEspecialidades = $this->getManager("ManagerEspecialidades");
$combo_especialidades=$ManagerEspecialidades->getCombo();
$this->assign("combo_especialidades",$combo_especialidades);