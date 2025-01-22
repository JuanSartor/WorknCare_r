<?php


  $ManagerMedico = $this->getManager("ManagerMedico");
  $info=$ManagerMedico->getInfoMenuMedico();

  $this->assign("info_medico",$info);

  $this->assign("sm", $this->request["sm"]);