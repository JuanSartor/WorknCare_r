<?php

  /**
   *  Médicos >>  Información comercial >> Alta 
   *  
   * */
  if (isset($this->request["idmedico"]) && $this->request["idmedico"] > 0) {
      $manager = $this->getManager("ManagerInformacionComercialMedico");
      $record = $manager->getInformacionComercialMedico($this->request["idmedico"]);

      $this->assign("record", $record);
  }

  //Combo Banco
  $ManagerBanco = $this->getManager("ManagerBanco");
  $this->assign("combo_banco", $ManagerBanco->getCombo());
  
  //Combo Condición de IVA
  $ManagerCondicionIVA = $this->getManager("ManagerCondicionIVA");
  $this->assign("combo_condicion_iva", $ManagerCondicionIVA->getCombo());