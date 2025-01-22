<?php

  if (isset($this->request["id"]) && $this->request["id"] != "") {
      $ManagerConsultorio = $this->getManager("ManagerConsultorio");
      $this->assign("consultorio", $ManagerConsultorio->get($this->request["id"]));
  }