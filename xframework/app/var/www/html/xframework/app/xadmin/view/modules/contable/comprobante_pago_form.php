<?php

  if (isset($this->request["id"]) && $this->request["id"] > 0) {
      $manager = $this->getManager("ManagerCuota");
      $this->assign("record", $manager->get($this->request["id"]));
  }