<?php

  /**
   *  BANNER >>  Alta - Modificación
   *  
   * */
  if (isset($this->request["id"]) && $this->request["id"] > 0) {

      $manager = $this->getManager("ManagerBanner");
      
      $record = $manager->get($this->request["id"]);

      $this->assign("record", $record);
  }

  $this->assign("combo_tipo_banner", $this->getManager("ManagerTipoBanner")->getCombo());