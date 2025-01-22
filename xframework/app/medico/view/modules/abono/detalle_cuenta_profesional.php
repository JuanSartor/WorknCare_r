<?php

 
  $idmedico = $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["medico"]["idmedico"];


  $ManagerMedico = $this->getManager("ManagerMedico");
  $medico = $ManagerMedico->get($idmedico, true);
  $this->assign("medico", $medico);
