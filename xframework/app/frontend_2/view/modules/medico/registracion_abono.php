<?php

  $this->assign("combo_especialidades", $this->getManager("ManagerEspecialidades")->getCombo());


  
  $this->assign("idmedico", $this->request["id"]);
  