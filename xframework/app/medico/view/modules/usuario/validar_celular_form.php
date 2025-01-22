<?php

  if(isset($this->request["idmedico"]) && $this->request["idmedico"] != ""){
      $ManagerPaciente = $this->getManager("ManagerMedico");
      $this->assign("medico", $ManagerPaciente->get($this->request["idmedico"]));
  }
