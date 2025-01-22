<?php

  $idpaciente = $this->request["idpaciente"];

  $ManagerPerfilSaludControlVisual = $this->getManager("ManagerPerfilSaludControlVisual");
  $control_visual = $ManagerPerfilSaludControlVisual->getInfoTablero($idpaciente);
  
      $this->assign("control_visual", $control_visual);
  
  
