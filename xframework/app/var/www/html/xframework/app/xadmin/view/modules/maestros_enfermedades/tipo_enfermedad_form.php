<?php

  /**
   *  Planes de las Obras Sociales / Prepaga >>  Alta
   *
   * */
  $ManagerEnfermedad = $this->getManager("ManagerEnfermedad");
    $enfermedad = $ManagerEnfermedad->get($this->request["enfermedad_idenfermedad"]);
  $this->assign("enfermedad", $enfermedad);


  if (isset($this->request["id"]) && $this->request["id"] > 0) {
      $manager = $this->getManager("ManagerTipoEnfermedad");
      $record = $manager->get($this->request["id"]);

      $this->assign("record", $record);
  }
