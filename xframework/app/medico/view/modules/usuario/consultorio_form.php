<?php

  $managerProvincia = $this->getManager("ManagerProvincia");
  $provincias = $managerProvincia->getComboProvinciasArgentinas();
  $this->assign("combo_provincias", $provincias);

  if (isset($this->request["id"]) && (int) $this->request["id"] > 0) {
      $managerConsultorio = $this->getManager("ManagerConsultorio");
      $this->assign("record", $managerConsultorio->get($this->request["id"]));
  }