<?php

  /**
   *  Banco >> Alta
   *  
   * */
  if (isset($this->request["id"]) && $this->request["id"] > 0) {
      $manager = $this->getManager("ManagerBanco");
      $record = $manager->get($this->request["id"]);

      $this->assign("record", $record);
  }