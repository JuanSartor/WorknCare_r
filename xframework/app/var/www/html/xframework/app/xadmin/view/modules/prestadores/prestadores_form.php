<?php

  /**
   *  Pacientes Form
   *
   * */
  if (isset($this->request["id"]) && (int) $this->request["id"] > 0) {
      $manager = $this->getManager("ManagerPrestador");

      //con el flag active=0 obtenemos todos los pacientes activos e inactivos
      $record = $manager->get($this->request["id"]);



      $this->assign("record", $record);

  } 

    $ManagerCondicionIVA = $this->getManager("ManagerCondicionIVA");
  $this->assign("combo_condicion_iva", $ManagerCondicionIVA->getCombo());
  
  $ManagerBanco = $this->getManager("ManagerBanco");
  $bancos= $ManagerBanco->getListadoBancos();

  $this->assign("listado_bancos", $bancos);
?>