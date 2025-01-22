<?php

  $this->assign("item_menu", "images");

  //Paciente que se encuentra en el array de SESSION de header paciente
  $ManagerPaciente = $this->getManager("ManagerPaciente");
  
  $paciente = $ManagerPaciente->getPacienteXSelectMedico($this->request["idpaciente"]);
  $this->assign("paciente", $paciente);
  
  if ($paciente) {
      $this->assign("paciente", $paciente);
      
      $ManagerPerfilSaludEstudios = $this->getManager("ManagerPerfilSaludEstudios");
      $paginate = $ManagerPerfilSaludEstudios->getDefaultPaginate();
      $this->assign("idpaginate", $paginate . "_" . $paciente["idpaciente"]);
      

      $this->request["idpaciente"] = $paciente["idpaciente"];
      $listado = $ManagerPerfilSaludEstudios->getListEstudiosMedico($this->request, $paginate . "_" . $paciente["idpaciente"]);
//      $ManagerPaciente->print_r($_SESSION['SmartyPaginate'][$paginate . "_" . $paciente["idpaciente"]]);
//      $ManagerPerfilSaludEstudios->print_r($listado);die();
      if ($listado) {
          $this->assign("listado_imagenes", $listado);
          $this->assign("cantidad_imagenes", count($listado));
      }
  }
