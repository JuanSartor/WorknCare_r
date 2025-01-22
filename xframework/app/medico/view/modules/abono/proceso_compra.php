<?php

  $idmedico = $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["medico"]["idmedico"];

  $ManagerMedico = $this->getManager("ManagerMedico");
  $medico = $ManagerMedico->get($idmedico, true);
  $this->assign("medico", $medico);
  
  $ManagerMetodoPago = $this->getManager("ManagerMetodoPago");
  $this->assign("combo_metodo_pago", $ManagerMetodoPago->getCombo());
  /*
  $enlace = $ManagerMetodoPago->getEnlaceMP($this->request);
  if($enlace){
      $this->assign("enlace_mp", $enlace);
  }*/