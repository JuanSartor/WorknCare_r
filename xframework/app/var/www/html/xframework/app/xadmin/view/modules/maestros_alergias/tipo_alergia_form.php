<?php

  /**
   *  Planes de las Obras Sociales / Prepaga >>  Alta
   *
   * */
  $ManagerTipoAlergia = $this->getManager("ManagerTipoAlergia");
    $tipoAlergia = $ManagerTipoAlergia->get($this->request["tipoAlergia_idtipoAlergia"]);
  $this->assign("tipoAlergia", $tipoAlergia);


  if (isset($this->request["id"]) && $this->request["id"] > 0) {
      $manager = $this->getManager("ManagerSubTipoAlergia");
      $record = $manager->get($this->request["id"]);

      $this->assign("record", $record);
  }
