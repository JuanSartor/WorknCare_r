<?php

  $this->assign("item_menu", "images");

  //Paciente que se encuentra en el array de SESSION de header paciente
  $ManagerPaciente = $this->getManager("ManagerPaciente");
//  $ManagerPaciente->debug();
  $paciente = $ManagerPaciente->getPacienteXSelectMedico($this->request["idpaciente"]);
  $this->assign("paciente", $paciente);
  
  //$ManagerPaciente->print_r($paciente);
  if ($paciente) {
      $this->assign("paciente", $paciente);
      
      $ManagerPerfilSaludEstudios = $this->getManager("ManagerPerfilSaludEstudios");
      $paginate = $ManagerPerfilSaludEstudios->getDefaultPaginate();
      $this->assign("idpaginate", $paginate . "_" . $paciente["idpaciente"]);

      $this->request["idpaciente"] = $paciente["idpaciente"];
      $this->request["do_reset"] = 1;
      $listado = $ManagerPerfilSaludEstudios->getListEstudiosMedico($this->request, $paginate . "_" . $paciente["idpaciente"]);

      if (count($listado["rows"]) > 0) {
          $this->assign("listado_imagenes", $listado);
          $this->assign("cantidad_imagenes", $ManagerPerfilSaludEstudios->getCantEstudiosPaciente($this->request));
      }
  }
  
   //Obtengo los tags INputs
      $ManagerPerfilSaludConsulta = $this->getManager("ManagerPerfilSaludConsulta");    
      $tags = $ManagerPerfilSaludConsulta->getInfoTags($paciente["idpaciente"]);
      if ($tags) {
          $this->assign("tags", $tags);
      }
 $estadoTablero=$this->getManager("ManagerPerfilSaludStatus")->getStatusPerfilPaciente($paciente["idpaciente"]);
 $this->assign("estadoTablero", $estadoTablero);

 $info_menu = $ManagerPaciente->getInfoMenu($paciente["idpaciente"]);
                    $this->assign("info_menu_paciente", $info_menu);
